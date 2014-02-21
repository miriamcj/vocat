class Attachment < ActiveRecord::Base

#  belongs_to :fileable, :polymorphic => true

  # Transcoding constants
  TRANSCODING_STATUS_NOT_STARTED = 0
  TRANSCODING_STATUS_SUCCESS = 1
  TRANSCODING_STATUS_ERROR = 2
  TRANSCODING_STATUS_UNNECESSARY = 3
  TRANSCODING_STATUS_BUSY = 4

  belongs_to :video
  belongs_to :user

  after_initialize :check_processing_state

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

    before_transition :uncommitted => :committed do |attachment, transition|
      attachment.do_commit
    end

    after_transition :committed => :processing do |attachment, transition|
      attachment.do_processing
    end

    after_transition any => :committed do |attachment, transition|
      if attachment.can_be_processed?
        attachment.start_processing
      else
        attachment.complete_processing
      end
    end
  end

  def check_processing_state
    if processing?
      processor = processor_class.constantize.new
      processor.check_for_and_handle_processing_completion(self, processor_job_id)
    end
  end

  def active_model_serializer
    AttachmentSerializer
  end

  def available_processors
    [
        AttachmentProcessor::Transcoder
    ]
  end

  def can_be_processed?
    available_processors.each do |processor_class|
      processor = processor_class.send(:new)
      if processor.can_process?(self)
        return true
      end
    end
    return false
  end

  def s3_thumb_key
    input_key = self.s3_source_key
    base = "#{File.dirname(input_key)}/#{File.basename(input_key, ".*")}"
    "#{base}_thumb00001.png"
  end

  def s3_source_key
    if uncommitted?
      uncommitted_s3_source_key
    else
      committed_s3_source_key
    end
  end

  def thumb
    if processed? and !processed_thumb_key.blank?
      s3 = get_s3_instance
      object = s3.buckets[Rails.application.config.vocat.aws[:s3_bucket]].objects[processed_thumb_key]
      object.url_for(:read).to_s
    end
  end

  def url
    if processed? and !processed_key.blank?
      key = processed_key
    else
      key = s3_source_key
    end
    s3 = get_s3_instance
    object = s3.buckets[Rails.application.config.vocat.aws[:s3_bucket]].objects[key]
    object.url_for(:read).to_s
  end

  def get_s3_instance
    options = {
        :access_key_id => Rails.application.config.vocat.aws[:key],
        :secret_access_key => Rails.application.config.vocat.aws[:secret]
    }
    s3 = AWS::S3.new(options)
    s3
  end

  def do_processing
    available_processors.each do |processor_class|
      processor = processor_class.send(:new)
      if processor.can_process?(self)
        processor.process(self)
        return true
      end
    end
  end

  def do_commit
    s3 = get_s3_instance
    object = s3.buckets[Rails.application.config.vocat.aws[:s3_bucket]].objects[uncommitted_s3_source_key]
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

end
