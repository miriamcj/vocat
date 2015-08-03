# == Schema Information
#
# Table name: attachment_variants
#
#  id              :integer          not null, primary key
#  attachment_id   :integer
#  location        :string
#  format          :string
#  state           :string
#  processor_name  :string
#  processor_data  :text
#  processor_error :string
#  created_at      :datetime
#  updated_at      :datetime
#  file_size       :integer
#  duration        :decimal(, )
#  width           :integer
#  height          :integer
#  metadata_saved  :boolean          default(FALSE)
#

class Attachment::Variant < ActiveRecord::Base

  include Storable

  scope :in_organization, ->(organization) {
    joins(:attachment => {:asset => {:submission => {:project => {:course => :organization}}}}).where('organizations.id = ?', organization.id)
  }
  scope :created_this_month, ->() {
    where("attachment_variants.created_at >= ? AND attachment_variants.created_at <= ?", Time.now.beginning_of_month, Time.now.end_of_month)
  }
  scope :created_in_month, ->(month, year) {
    start_date = Time.new(year, month, 1)
    end_date = start_date.end_of_month
    where("attachment_variants.created_at >= ? AND attachment_variants.created_at <= ?", start_date, end_date)
  }
  scope :created_before, ->(month, year) {
    end_date = Time.new(year, month, 1).end_of_month
    where("attachment_variants.created_at < ?", end_date)
  }

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

  def extension
    File.extname(location).split('.').last
  end

  def processor
    processor_name.constantize.new
  end

  def has_processing_error?
    !processor_error.blank?
  end

  def job_id
    if processor_data.blank?
      return nil
    else
      data = JSON.parse(processor_data)
      if data.has_key?('job_id')
        return data['job_id']
      else
        return nil
      end
    end
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

  def update_content_length
    if state == 'processed' && file_size.blank?
      credentials = {
          :access_key_id => Rails.application.config.vocat.aws[:key],
          :secret_access_key => Rails.application.config.vocat.aws[:secret]
      }
      AWS.config(credentials)
      s3 = AWS::S3.new()
      bucket = s3.buckets[Rails.application.config.vocat.aws[:s3_bucket]]
      s3_obj = bucket.objects[location]
      if s3_obj.exists?
        self.file_size = s3_obj.content_length
        self.save
        return true
      end
    end
    return false
  end

  def update_job_metadata
    if !self.metadata_saved
      credentials = {
          :access_key_id => Rails.application.config.vocat.aws[:key],
          :secret_access_key => Rails.application.config.vocat.aws[:secret]
      }
      AWS.config(credentials)
      et = AWS::ElasticTranscoder::Client.new({:region => Rails.application.config.vocat.aws[:s3_region]})
      job_id = self.job_id
      if !job_id.blank?
        et_job = et.read_job({id: job_id})
        output = et_job[:job][:output]
        if output
          self.duration = output[:duration]
          self.width = output[:width]
          self.height = output[:height]
          self.metadata_saved = true
          self.save
          return true
        end
      end
    end
    return false
  end


end
