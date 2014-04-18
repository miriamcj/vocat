class Attachment < ActiveRecord::Base

  belongs_to :video
  belongs_to :user
  has_many :variants

  after_initialize :check_processing_state
  validates_presence_of :media_file_name

  state_machine :initial => :uncommitted do
    state :uncommitted
    state :committed
    state :processing
    state :processing_error
    state :processed

    event :commit do
      transition :uncommitted => :committed
    end

    event :complete_processing do
      transition :committed => :processed
      transition :processing => :processed
      transition :processing_error => :processed
    end

    event :start_processing do
      transition :committed => :processing
    end

    event :stop_processing_with_error do
      transition :processing => :processing_error
    end

    before_transition :uncommitted => :committed do |attachment|
      attachment.do_commit
    end

    after_transition :committed => :processing do |attachment|
      attachment.process
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
    File.extname(media_file_name)
  end

  def variant_by_format(format)
    variants.where(:format => format).first
  end

  def check_processing_state
    if processing?
      if variants.with_state(:processing).count > 0
        variants.with_state(:processing).each do |variant|
          variant.check_processing_state
        end
      else
        self.complete_processing
        self.save
      end
    end
  end

  def active_model_serializer
    AttachmentSerializer
  end

  def all_processors
    [
        Attachment::Processor::Transcoder::Mp4,
        Attachment::Processor::Transcoder::Webm
    ]
  end

  def locations
    locations = variants.with_state(:processed).map do |variant|
      [variant.format, variant.public_location]
    end
    Hash[locations]
  end

  def available_processors
    processors = all_processors.collect do |processor_class|
      processor = processor_class.send(:new)
      processor.can_process?(self) ? processor : nil
    end
    processors.compact
  end

  def process
    available_processors.each do |processor|
      processor.process(self)
    end
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
      uncommitted_s3_source_key
    else
      committed_s3_source_key
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

  def bucket
    Rails.application.config.vocat.aws[:s3_bucket]
  end

  def do_commit
    s3 = get_s3_instance
    object = s3.buckets[bucket].objects[uncommitted_s3_source_key]
    self.media_content_type = MIME::Types.type_for(media_file_name).first.simplified
    self.media_file_size = object.content_length
    self.media_updated_at = Time.now
    object.move_to(committed_s3_source_key)
    self.save
  end

  private

  def committed_s3_source_key
    ext = File.extname(media_file_name)
    lower_thousand = (id/1000).floor * 1000
    upper_thousand = lower_thousand + 1000
    lower_hundred = (id/100).floor * 100
    upper_hundred = lower_hundred + 100
    "source/attachment/#{lower_thousand}_#{upper_thousand}/#{lower_hundred}_#{upper_hundred}/#{id}#{ext}"
  end

  def uncommitted_s3_source_key
    ext = File.extname(media_file_name)
    lower_thousand = (id/1000).floor * 1000
    upper_thousand = lower_thousand + 1000
    lower_hundred = (id/100).floor * 100
    upper_hundred = lower_hundred + 100
    "temporary/attachment/#{lower_thousand}_#{upper_thousand}/#{lower_hundred}_#{upper_hundred}/#{id}#{ext}"
  end

  def get_s3_instance
    options = {
        :access_key_id => Rails.application.config.vocat.aws[:key],
        :secret_access_key => Rails.application.config.vocat.aws[:secret]
    }
    s3 = AWS::S3.new(options)
    s3
  end

end
