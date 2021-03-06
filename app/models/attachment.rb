# == Schema Information
#
# Table name: attachments
#
#  id                  :integer          not null, primary key
#  media_file_name     :string
#  media_content_type  :string
#  media_file_size     :integer
#  media_updated_at    :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  state               :string
#  processor_error     :string
#  user_id             :integer
#  processed_key       :string
#  processor_job_id    :string
#  processor_class     :string
#  processed_thumb_key :string
#  processing_data     :hstore
#  asset_id            :integer
#

require 'action_view'
include ActionView::Helpers::NumberHelper

class Attachment < ApplicationRecord

  include Storable

  belongs_to :asset
  belongs_to :user
  has_many :variants, dependent: :destroy

  ALL_PROCESSORS = [
      Attachment::Processor::Transcoder::Mp3,
      Attachment::Processor::Transcoder::Mp4,
      Attachment::Processor::Transcoder::Webm,
      Attachment::Processor::ThumbnailGenerator,
      Attachment::Processor::MobileImageGenerator
  ]

  scope :in_organization, ->(organization) {
    joins(:asset => {:submission => {:project => {:course => :organization}}}).where('organizations.id = ?', organization.id)
  }
  scope :created_this_month, ->() {
    where("attachments.created_at >= ? AND attachments.created_at <= ?", Time.now.beginning_of_month, Time.now.end_of_month)
  }
  scope :created_in_month, ->(month, year) {
    start_date = Time.new(year, month, 1)
    end_date = start_date.end_of_month
    where("attachments.created_at >= ? AND attachments.created_at <= ?", start_date, end_date)
  }
  scope :created_before, ->(month, year) {
    end_date = Time.new(year, month, 1).end_of_month
    where("attachments.created_at < ?", end_date)
  }


  after_destroy :destroy_file_object
  after_initialize :check_processing_state
  after_commit :check_if_processing_is_needed, :on => [:create, :update]

  validates_presence_of :media_file_name

  state_machine :initial => :uncommitted do
    state :uncommitted
    state :committed
    state :processing
    state :processing_error
    state :processed

    event :undo_processing do
      transition :processing => :committed
      transition :processed => :committed
    end

    event :commit do
      transition :uncommitted => :committed
    end

    event :complete_processing do
      transition :committed => :processed
      transition :processing => :processed
      transition :processing_error => :processed
    end

    event :complete_processing_with_error do
      transition :committed => :processing_error
      transition :processing => :processing_error
    end

    event :start_processing do
      transition :committed => :processing
    end

    event :stop_processing_with_error do
      transition :processing => :processing_error
    end

    before_transition :uncommitted => :committed do |attachment|
      attachment.move_media_to_committed_location
    end

    after_transition :committed => :processing do |attachment|
      attachment.start_processors
    end

    # after_transition any => :committed do |attachment|
    #   if attachment.can_be_processed?
    #     attachment.start_processing
    #   else
    #     attachment.complete_processing
    #   end
    # end
  end

  def check_if_processing_is_needed
    if committed? && can_be_processed?
      start_processing
    elsif committed? && !can_be_processed?
      complete_processing
    end
  end

  def extension()
    File.extname(media_file_name).downcase
  end

  def variant_by_format(format, state = nil)
    if state
      variants.where(:format => format, :state => state).first
    else
      variants.where(:format => format).first
    end
  end

  def commit_if_attached
    if uncommitted? && asset
      commit
    end
  end


  def check_processing_state
    if processing?
      processing_complete = true
      processing_error = false

      # Check if any variants are still processing
      if variants.count > 0
        variants.each do |variant|
          variant.check_processing_state
          processing_complete = false unless variant.processing_complete?
          processing_error = true unless !variant.has_processing_error?
        end
      end

      if !can_be_processed?
        processing_complete = true
        processing_error = false
      end

      #If all processing is done, then we complete the attachment's processing
      if processing_complete == true
        if processing_error == false
          self.complete_processing
        else
          self.complete_processing_with_error
        end
        self.save
      end
    elsif committed? && !can_be_processed?
      complete_processing
      self.save
    end
  end

  def active_model_serializer
    AttachmentSerializer
  end

  def locations
    formats = []
    locations = variants.with_state(:processed).map do |variant|
      formats.push variant.format
      [variant.format, variant.public_location]
    end
    ext = extension.gsub('.', '')
    unless formats.include? ext
      locations.push [ext, public_location]
    end
    Hash[locations]

  end

  def available_processors
    processors = ALL_PROCESSORS.collect do |processor_class|
      processor = processor_class.send(:new)
      processor.can_process?(self) ? processor : nil
    end
    processors.compact
  end

  def has_all_variants?
    all_there = true
    available_processors.each do |processor|
      if variants.where(:processor_name => processor.class.name).count == 0
        all_there = false
      end
    end
    all_there
  end

  def can_be_processed?
    true if available_processors.length > 0
  end

  def dirname
    File.dirname(location)
  end

  def basename
    File.basename(location, ".*")
  end

  def location
    if uncommitted?
      uncommitted_location
    else
      committed_location
    end
  end

  def size
    number_to_human_size media_file_size
  end

  def thumb
    variant = variant_by_format(['mp4_thumb', 'webm_thumb', 'jpg_thumb'], :processed)
    if variant.nil?
      return nil
    else
      return variant.public_location
    end
  end

  def start_processors
    available_processors.each do |processor|
      processor.process(self)
    end
  end

  def move_media_to_committed_location
    s3 = get_s3_instance
    uncommitted_object = s3.buckets[bucket].objects[uncommitted_location]
    uncommitted_object.move_to(committed_location)
    committed_object = s3.buckets[bucket].objects[committed_location]
    self.media_file_size = committed_object.content_length
    self.media_content_type = MIME::Types.type_for(media_file_name).first.simplified
    self.media_updated_at = Time.now
    self.save
  end


  private

  def committed_location
    ext = File.extname(media_file_name)
    out = "source/attachment/#{path_segment}/#{id}#{ext}"
    out
  end

  def uncommitted_location
    ext = File.extname(media_file_name)
    "temporary/attachment/#{path_segment}/#{id}#{ext}"
  end

end
