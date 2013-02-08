class AssignmentSubmission < ActiveRecord::Base
  attr_accessible :description, :name, :media

  # Transcoding constants
  TRANSCODING_STATUS_BUSY = 0
  TRANSCODING_STATUS_SUCCESS = 1
  TRANSCODING_STATUS_ERROR = 2

  # Paperclip configurations
  has_attached_file :media,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/aws.yml",
                    :path => ":year/:month/:day/:hash:ending",
                    :hash_secret => "+hequ!ckbr0wnf@Xjump5o^3rThe1azyd0g"

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
        if media_content_type == "video/mp4"
          self.update_attribute(:transcoding_status, TRANSCODING_STATUS_SUCCESS)
          return true
        end
        extension = "mp4"
      else
        return
    end

    # Create the ElasticTranscoder object
    options = media.s3_credentials
    trans_opts = options[:transcoding][extension]
    et = AWS::ElasticTranscoder.new(options)

    input_key = media.interpolator.interpolate media.options[:path], media, :original
    base = "#{File.dirname(input_key)}/#{File.basename(input_key, ".*")}"
    output_key = "#{base}.#{extension}"
    thumb_pattern = "#{base}_thumb{count}"

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
