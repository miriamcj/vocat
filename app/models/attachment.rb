class Attachment < ActiveRecord::Base
  attr_accessible :media

  # Transcoding constants
  TRANSCODING_STATUS_BUSY = 0
  TRANSCODING_STATUS_SUCCESS = 1
  TRANSCODING_STATUS_ERROR = 2

  # Paperclip configurations
  has_attached_file :media,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/aws.yml",
                    :s3_permissions => :private,
                    :path => ":year/:month/:day/:hash:ending",
                    :hash_secret => "+hequ!ckbr0wnf@Xjump5o^3rThe1azyd0g",
                    :hash_data => "attachment/:id/:updated_at"

  Paperclip.interpolates(:year)  {|a, style| a.instance.created_at.year}
  Paperclip.interpolates(:month) {|a, style| a.instance.created_at.month}
  Paperclip.interpolates(:day)   {|a, style| a.instance.created_at.day}
  Paperclip.interpolates(:ending) do |a, style|
    if a.instance.transcoding_complete?
      case style
        when :original
          ".mp4"
        when :thumb
          "_thumb00001.png"
        else
          File.extname(a.instance.media_file_name)
      end
    else
      File.extname(a.instance.media_file_name)
    end
  end

  # Validations
  validates :media, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :media

  # Start transcoding right after saving attachment
  after_save :transcode_media

  # Some wrappers
  def url(style = :original)
    media.expiring_url(Time.now + 3600, style)
  end
  def to_s
    self.url
  end
  def size
    media.size
  end
  def original_filename
    media_file_name
  end
  def content_type
    media_content_type
  end



  # A method for generically running the transcoding
  def transcode_media
    transcode(:mp4)
  end

  # Determine if the transcoding is complete
  def transcoding_complete?
    self.transcoding_status != TRANSCODING_STATUS_BUSY
  end

  protected

  # Queues an AWS transcoding job
  def transcode(encoding)
    return true if self.transcoding_complete? # prevents recursion

    case encoding
      when :mp4,"mp4"
        extension = "mp4"
      else
        return
    end

    # Create the ElasticTranscoder object and S3 object
    options = media.s3_credentials
    trans_opts = options[:transcoding][extension]
    et = AWS::ElasticTranscoder.new(options)
    s3 = AWS::S3.new(options)

    # Get the transcoding variables
    input_key = media.interpolator.interpolate media.options[:path], media, :original
    base = "#{File.dirname(input_key)}/#{File.basename(input_key, ".*")}"
    output_key = "#{base}.#{extension}"
    thumb_pattern = "#{base}_thumb{count}"

    # Can't override files
    if input_key == output_key
      input_file = s3.buckets[options[:bucket]].objects[input_key]
      input_key = "#{input_key}_original"
      input_file.move_to(input_key)
    end

    # Queue the job
    job = et.client.create_job(
        :pipeline_id => trans_opts['pipeline'],
        :input => {
            :key => input_key,
            :frame_rate => 'auto',
            :resolution => 'auto',
            :aspect_ratio => 'auto',
            :interlaced => 'auto',
            :container => 'auto'
        },
        :output => {
            :key => output_key,
            :thumbnail_pattern => thumb_pattern,
            :rotate => '0',
            :preset_id => trans_opts['preset']
        })

    # Poll the job queue to see if the job is done yet
    Thread.new(options, job.data[:job][:id], &method(:listen_for_transcoding_completion))

  end

  # Polls the AWS job queue to see if the given
  def listen_for_transcoding_completion(options, job_id)
    et = AWS::ElasticTranscoder.new(options)

    50.times do
      job = et.client.read_job(:id => job_id)
      status = job.data[:job][:output][:status]
      case status
        when 'Complete'
          self.update_attribute(:transcoding_status, TRANSCODING_STATUS_SUCCESS)
          break
        when 'Error'
          self.update_attribute(:transcoding_status, TRANSCODING_STATUS_ERROR)
          self.update_attribute(:transcoding_error, job.data[:job][:output][:status_detail])
          break
        else
          sleep 1
      end
    end
  end



end
