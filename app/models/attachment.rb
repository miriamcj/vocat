class Attachment < ActiveRecord::Base
  attr_accessible :media
  belongs_to :fileable, :polymorphic => true
  has_many :annotations

  # Transcoding constants
  TRANSCODING_STATUS_NOT_STARTED = 0
  TRANSCODING_STATUS_SUCCESS = 1
  TRANSCODING_STATUS_ERROR = 2
  TRANSCODING_STATUS_UNNECESSARY = 3
  TRANSCODING_STATUS_BUSY = 4

  # Paperclip configurations
  has_attached_file :media,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/aws.yml",
                    :s3_permissions => :private,
                    :path => ":year/:month/:day/:hash:ending",
                    :hash_secret => "+hequ!ckbr0wnf@Xjump5o^3rThe1azyd0g",
                    :hash_data => Rails.env == "production" ? "attachment/:id/:updated_at" : "attachment/:updated_at" # need to predictably seed attachments


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

  # Typically one attachment, so get the most recent to the top
  default_scope order("updated_at DESC")

  def active_model_serializer
    AttachmentSerializer
  end

  # Some wrappers
  def url(style = :original)
    case style
    when :original
      media.expiring_url(Time.now + 3600, style)
    when :thumb
      media.url :thumb
    end
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

  def make_thumbnail_public
    options = media.s3_credentials
    input_key = media.interpolator.interpolate media.options[:path], media, :original
    base = "#{File.dirname(input_key)}/#{File.basename(input_key, ".*")}"
    target_key = "#{base}_thumb00001.png"

    s3 = AWS::S3.new(options)
    s3.client.put_object_acl(
      bucket_name: options[:bucket],
      key: target_key,
      acl: "public_read"
    )
  end

  def is_video?
    case media_content_type
      when "video/mpeg","video/mp4","video/ogg","video/quicktime","video/webm","video/x-matroska","video/x-ms-wmv","video/x-flv","video/avi"
        return true
      else
        return false
    end
  end

  # A method for generically running the transcoding
  def transcode_media
    transcoding_happened = FALSE
    self.update_column(:transcoding_status , TRANSCODING_STATUS_BUSY)

    # Skip transcoding for non-movie files
    unless is_video?
        self.update_column(:transcoding_status, TRANSCODING_STATUS_UNNECESSARY)
        return
    end


    options = media.s3_credentials
    trans_opts = options[:transcoding]
    if trans_opts
      trans_opts.each do |encoding,v|
        transcode(encoding)
        transcoding_happened = TRUE
      end
    end
    unless transcoding_happened
      self.update_column(:transcoding_status, TRANSCODING_STATUS_SUCCESS)
    end
  end

  # Determine if the transcoding is complete
  def transcoding_complete?
    self.transcoding_status == TRANSCODING_STATUS_SUCCESS ||
        self.transcoding_status == TRANSCODING_STATUS_UNNECESSARY ||
        self.transcoding_status == TRANSCODING_STATUS_ERROR
  end

  def transcoding_in_progress?
    self.transcoding_status == TRANSCODING_STATUS_BUSY
  end

  protected

  # Queues an AWS transcoding job
  def transcode(encoding)

    extension = encoding.to_s

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

  def transcoding_not_started
    self.transcoding_status == TRANSCODING_STATUS_NOT_STARTED
  end

  def transcoding_error
    self.transcoding_status == TRANSCODING_STATUS_ERROR
  end

  def transcoding_unnecessary
    self.transcoding_status == TRANSCODING_STATUS_UNNECESSARY
  end

  def transcoding_busy
    self.transcoding_status == TRANSCODING_STATUS_BUSY
  end

  def transcoding_success
    self.transcoding_status == TRANSCODING_STATUS_SUCCESS
  end

  # Polls the AWS job queue to see if the given
  def listen_for_transcoding_completion(options, job_id)
    et = AWS::ElasticTranscoder.new(options)

    finished_transcoding = FALSE
    300.times do
      job = et.client.read_job(:id => job_id)
      status = job.data[:job][:output][:status]
      case status
        when 'Complete'
          self.update_column(:transcoding_status, TRANSCODING_STATUS_SUCCESS)
          self.make_thumbnail_public
          finished_transcoding = TRUE
          break
        when 'Error'
          self.update_column(:transcoding_status, TRANSCODING_STATUS_ERROR)
          self.update_column(:transcoding_error, job.data[:job][:output][:status_detail])
          finished_transcoding = TRUE
          break
        else
          sleep 1
      end
    end
    unless finished_transcoding
      self.update_column(:transcoding_status, TRANSCODING_STATUS_ERROR)
      self.update_column(:transcoding_error, "Transcoding took too long. Please upload a smaller video file.")
    end
  end


end
