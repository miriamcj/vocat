class AssignmentSubmission < ActiveRecord::Base
  attr_accessible :description, :name, :media
  has_attached_file :media,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/aws.yml",
                    :path => ":year/:month/:day/:hash.:extension",
                    :hash_secret => "+hequ!ckbr0wnf@Xjump5o^3rThe1azyd0g"

  Paperclip.interpolates(:year)  {|a, style| (a.instance.created_at && a.instance.created_at.year)  || Time.new.year }
  Paperclip.interpolates(:month) {|a, style| (a.instance.created_at && a.instance.created_at.month) || Time.new.month }
  Paperclip.interpolates(:day)   {|a, style| (a.instance.created_at && a.instance.created_at.day)   || Time.new.day }

  validates :media, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :media

  after_save :transcode_media

  def transcode_media
    transcode(:mp4)
  end

  protected

  def transcode(encoding)
    case encoding
      when :mp4,"mp4"
        return if media_content_type == "video/mp4"
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

    listenForJobCompletion(media, options, job.data[:job][:id])

    # Poll the job queue to see if the job is done yet
    #Thread.new(media, options, job.data[:job][:id])

  end

  def listenForJobCompletion(media, options, job_id)
    puts "THREAD STARTED"
    et = AWS::ElasticTranscoder.new(options)

    20.times do
      puts "CHECKING STATUS"
      job = et.client.read_job(:id => job_id)
      status = job.data[:job][:output][:status]
      case status
        when 'Complete'
          puts "JOB COMPLETED SUCCESSFULLY"
          break
        when 'Error'
          puts "JOB FAILED"
          break
        else
          sleep 1
      end
    end
  end



end
