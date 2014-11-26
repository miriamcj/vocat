class Attachment < ActiveRecord::Base

  belongs_to :asset
  belongs_to :user
  has_many :variants, dependent: :destroy

  ALL_PROCESSORS = [
      Attachment::Processor::Transcoder::Mp4,
      Attachment::Processor::Transcoder::Webm
  ]

  after_destroy :destroy_file_object
  after_initialize :check_processing_state

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

    after_transition any => :committed do |attachment|
      if attachment.can_be_processed?
        attachment.start_processing
      else
        attachment.complete_processing
      end
    end
  end

  def extension()
    File.extname(media_file_name).downcase
  end

  def variant_by_format(format)
    variants.where(:format => format).first
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

      #If all processing is done, then we complete the attachment's processing
      if processing_complete == true
        if processing_error == false
          self.complete_processing
        else
          self.complete_processing_with_error
        end
        self.save
      end
    end
  end

  def active_model_serializer
    AttachmentSerializer
  end

  def locations
    locations = variants.with_state(:processed).map do |variant|
      [variant.format, variant.public_location]
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

  def thumb
    variant = variant_by_format(['mp4_thumb', 'webm_thumb'])
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

  def path_segment
    lower_thousand = (id/1000).floor * 1000
    upper_thousand = lower_thousand + 1000
    lower_hundred = (id/100).floor * 100
    upper_hundred = lower_hundred + 100
    "#{lower_thousand}_#{upper_thousand}/#{lower_hundred}_#{upper_hundred}"
  end

  def s3_upload_document
    policy = s3_upload_policy_document(location)
    {
      :policy => policy,
      :signature => s3_upload_signature(location, policy),
      :key => location
    }
  end

  private

  def bucket
    Rails.application.config.vocat.aws[:s3_bucket]
  end

  def destroy_file_object
    s3 = get_s3_instance
    object = s3.buckets[bucket].objects[location]
    object.delete if object.exists?
  end

  def committed_location
    ext = File.extname(media_file_name)
    out = "source/attachment/#{path_segment}/#{id}#{ext}"
    out
  end

  def uncommitted_location
    ext = File.extname(media_file_name)
    "temporary/attachment/#{path_segment}/#{id}#{ext}"
  end

  def get_s3_instance
    options = {
        :access_key_id => Rails.application.config.vocat.aws[:key],
        :secret_access_key => Rails.application.config.vocat.aws[:secret]
    }
    s3 = AWS::S3.new(options)
    s3
  end

  # generate the policy document that amazon is expecting.
  def s3_upload_policy_document(key)
    ret = {
      "expiration" => 15.minutes.from_now.utc.xmlschema,
      "conditions" =>  [
        {"bucket" =>  Rails.application.config.vocat.aws[:s3_bucket]},
        ["starts-with", "$key", key],
        {"acl" => "private"},
        {"success_action_status" => "200"},
        ["content-length-range", 0, 5368709120]
      ]
    }
    Base64.encode64(ret.to_json).gsub(/\n/,'')
  end

  def s3_upload_signature(key, policy)
    secret = Rails.application.config.vocat.aws[:secret]
    signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret, policy)).gsub("\n","")
  end


end
