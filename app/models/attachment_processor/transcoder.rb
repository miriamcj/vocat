class AttachmentProcessor::Transcoder

  def process(attachment)
    transcode(attachment)
  end

  def bucket_name
    Rails.application.config.vocat.aws[:s3_bucket]
  end

  def credentials
    {
        :access_key_id => Rails.application.config.vocat.aws[:key],
        :secret_access_key => Rails.application.config.vocat.aws[:secret]
    }
  end

  def make_thumbnail_public(attachment)
    thumb_key = attachment.s3_thumb_key
    s3 = AWS::S3.new(credentials)
    s3.client.put_object_acl(
      bucket_name: bucket_name,
      key: thumb_key,
      acl: 'public_read'
    )
  end

  def can_process?(attachment)
    file = attachment.media_file_name
    ext = File.extname(file)
    case ext
      when ".avi",".mp4",".mov",".flv"
        return true
      else
        return false
    end
  end

  def transcode(attachment)

    extension = 'mp4'

    # Create the ElasticTranscoder object and S3 object
    AWS.config(credentials)
    et = AWS::ElasticTranscoder::Client.new({:region => Rails.application.config.vocat.aws[:s3_region]})
    s3 = AWS::S3.new(credentials)

    # Get the transcoding variables
    input_key = attachment.s3_source_key
    base = "#{File.dirname(input_key)}/#{File.basename(input_key, ".*")}"
    output_key = "#{base}_processed.#{extension}"
    thumb_pattern = "#{base}_thumb{count}"

    # Can't override files
    if input_key != output_key
      pipeline = Rails.application.config.vocat.aws[:et_pipeline]
      preset = Rails.application.config.vocat.aws[:et_preset]

      job = et.create_job(
          :pipeline_id => Rails.application.config.vocat.aws[:et_pipeline],
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
              :preset_id => Rails.application.config.vocat.aws[:et_preset]
          })

      attachment.processed_key = output_key
      attachment.processed_thumb_key = attachment.s3_thumb_key
      attachment.processor_class = "AttachmentProcessor::Transcoder"
      attachment.processor_job_id = job.data[:job][:id]
      attachment.save
    else
      # TODO: Raise exception
    end

  end

  def check_for_and_handle_processing_completion(attachment, job_id)
    AWS.config(credentials)
    et = AWS::ElasticTranscoder::Client.new({:region => Rails.application.config.vocat.aws[:s3_region]})
    finished_transcoding = FALSE
    job = et.read_job(:id => job_id)
    status = job.data[:job][:output][:status]
    case status
      when 'Complete'
        make_thumbnail_public(attachment)

        attachment.complete_processing
        attachment.save
      when 'Error'
        attachment.stop_processing_with_error
        attachment.processor_error = job.data[:job][:output][:status_detail]
        attachment.save
    end
  end

end
