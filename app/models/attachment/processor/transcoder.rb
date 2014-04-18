module Attachment::Processor::Transcoder

  include(Attachment::Processor)

  TRANSCODER_INPUT_FORMATS = [".avi",".mp4",".mov",".flv"]

  def do_processing(variant)
    transcode(variant)
  end

  def processing_finished?(variant)
    AWS.config(credentials)
    et = AWS::ElasticTranscoder::Client.new({:region => Rails.application.config.vocat.aws[:s3_region]})

    processor_data = ActiveSupport::JSON.decode(variant.processor_data)
    job_id = processor_data['job_id']
    job = et.read_job(:id => job_id)
    status = job.data[:job][:output][:status]

    case status
      when 'Complete'
        variant.finish_processing
        variant.save
        create_thumb_variant(variant)
      when 'Error'
        variant.halt_processing
        variant.processor_error =job.data[:job][:output][:status_detail]
        variant.save
    end
  end


  protected

  def create_thumb_variant(variant)
    processor_data = ActiveSupport::JSON.decode(variant.processor_data)
    thumb_location = processor_data['thumb_location']
    thumb_format = "#{@output_format}_thumb"
    existing_thumb = variant.attachment.variant_by_format(thumb_format)
    unless existing_thumb.nil?
      existing_thumb.destroy()
    end
    thumb_variant = create_variant(variant.attachment)
    thumb_variant.format = thumb_format
    thumb_variant.location = thumb_location
    thumb_variant.finish_processing
    thumb_variant.save

    s3 = AWS::S3.new(credentials)
    s3.client.put_object_acl(
      bucket_name: bucket_name,
        key: thumb_location,
        acl: 'public_read'
    )
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

  def get_preset_id
    myvar = Rails.application.config.vocat
    Rails.application.config.vocat.aws[:presets][@output_format]
  end

  def transcode(variant)

    # Create the ElasticTranscoder object and S3 object
    AWS.config(credentials)
    et = AWS::ElasticTranscoder::Client.new({:region => Rails.application.config.vocat.aws[:s3_region]})

    # Get the transcoding variables
    attachment = variant.attachment
    input_location = attachment.location
    base_location = "#{attachment.dirname}/#{attachment.basename}"
    output_location = "#{base_location}_processed.#{@output_format}"
    thumb_base = "#{base_location}_#{@output_format}_thumb"
    thumb_pattern = "#{thumb_base}{count}"
    thumb_location = "#{thumb_base}00001.png"

    # Check if objects exists at output locations and, if so, remove them.
    s3 = AWS::S3.new(credentials)
    if s3.buckets[bucket_name].objects[output_location].exists?
      s3.buckets[bucket_name].objects[output_location].delete
    end
    if s3.buckets[bucket_name].objects[thumb_location].exists?
      s3.buckets[bucket_name].objects[thumb_location].delete
    end

    # Request the new object.
    job = et.create_job(
      :pipeline_id => Rails.application.config.vocat.aws[:et_pipeline],
      :input => {
        :key => input_location,
        :frame_rate => 'auto',
        :resolution => 'auto',
        :aspect_ratio => 'auto',
        :interlaced => 'auto',
        :container => 'auto'
      },
      :output => {
        :key => output_location,
        :thumbnail_pattern => thumb_pattern,
        :rotate => '0',
        :preset_id => get_preset_id
      })

    processor_data = {
        job_id: job.data[:job][:id],
        thumb_location: thumb_location
    }
    variant.location = output_location
    variant.processor_data = ActiveSupport::JSON.encode(processor_data)
    variant
  end




end
