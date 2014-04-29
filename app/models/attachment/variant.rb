class Attachment::Variant < ActiveRecord::Base

  belongs_to :attachment
  after_destroy :destroy_file_object

  state_machine :initial => :unprocessed do
    state :unprocessed
    state :processing
    state :processed

    event :start_processing do
      transition :unprocessed => :processing
    end

    event :finish_processing do
      transition :unprocessed => :processed
      transition :processing => :processed
    end

    event :halt_processing do
      transition :processing => :unprocessed
    end
  end

  def processor
    processor_name.constantize.new
  end

  def has_processing_error?
    !processor_error.blank?
  end

  def processing_complete?
    return true if processed?
    return true if unprocessed? && has_processing_error?
  end

  def sibling_variant_by_format(format)
    self.attachment.variant_by_format(format)
  end

  def check_processing_state
    processor.processing_finished?(self)
  end

  def bucket
    Rails.application.config.vocat.aws[:s3_bucket]
  end

  def get_s3_instance
    options = {
        :access_key_id => Rails.application.config.vocat.aws[:key],
        :secret_access_key => Rails.application.config.vocat.aws[:secret]
    }
    s3 = AWS::S3.new(options)
    s3
  end

  def public_location
    s3 = get_s3_instance
    object = s3.buckets[bucket].objects[location]
    object.url_for(:read).to_s
  end

  def destroy_file_object
    s3 = get_s3_instance
    unless location.blank?
      object = s3.buckets[bucket].objects[location]
      object.delete if object.exists?
    end
  end


end
