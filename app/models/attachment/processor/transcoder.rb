module Attachment::Processor::Transcoder

  include(Attachment::Processor)

  TRANSCODER_INPUT_FORMATS = [".avi",".mp4",".m4v",".mov",".flv", ".wmv"]

  def do_processing(variant)
    transcode(variant)
  end

  def processing_finished?(variant)
    AWS.config(credentials)
    et = AWS::ElasticTranscoder::Client.new({:region => Rails.application.config.vocat.aws[:s3_region]})
    unless variant.processor_data.blank?
      parsed_processor_data = ActiveSupport::JSON.decode(variant.processor_data)
      job_id = parsed_processor_data['job_id']
      job = et.read_job(:id => job_id)
      status = job.data[:job][:output][:status]

      case status
        when 'Complete'
          variant.finish_processing
          variant.save
          create_thumb_variant(parsed_processor_data, variant.attachment_id)
        when 'Error'
          variant.halt_processing
          variant.location = nil
          variant.processor_error =job.data[:job][:output][:status_detail]
          variant.save
      end
    end
  end


  protected

  def create_thumb_variant(parsed_processor_data, attachment_id)
    thumb_location = parsed_processor_data['thumb_location']
    s3 = AWS::S3.new(credentials)
    if s3.buckets[bucket_name].objects[thumb_location].exists?
      s3.client.put_object_acl(
          bucket_name: bucket_name,
          key: thumb_location,
          acl: 'public_read'
      )
    end

    thumb_format = "#{@output_format}_thumb"
    thumb_variant = Attachment::Variant.find_or_create_by(
        :attachment_id => attachment_id,
        :format => thumb_format,
        :processor_name => self.class.name
    )
    thumb_variant.format = thumb_format
    thumb_variant.location = thumb_location
    thumb_variant.finish_processing
    thumb_variant.save
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
    out = Rails.application.config.vocat.aws[:presets][@output_format]
    out
  end

  def transcode(variant)

    # Create the ElasticTranscoder object and S3 object
    AWS.config(credentials)
    et = AWS::ElasticTranscoder::Client.new({:region => Rails.application.config.vocat.aws[:s3_region]})

    # Get the transcoding variables
    attachment = variant.attachment
    input_location = attachment.location
    output_location = "processed/attachment/#{attachment.path_segment}/#{attachment.id}_transcoded.#{@output_format}"
    thumb_base = "processed/attachment/#{attachment.path_segment}/#{attachment.id}_thumb.#{@output_format}"
    thumb_pattern = "#{thumb_base}{count}"
    thumb_location = "#{thumb_base}00001.png"

    # Check if objects exists at output locations and, if so, remove them.
    s3 = AWS::S3.new(credentials)
    object_exists = s3.buckets[bucket_name].objects[output_location].exists?
    thumb_exists = s3.buckets[bucket_name].objects[thumb_location].exists?

    # To save money and computing power, if the variant and its thumbnail already
    # exists in the destination, we'll just use that.
    if object_exists == true && thumb_exists == true
      variant.location = output_location
      variant.location = output_location
      variant.finish_processing
      processor_data = {
          'thumb_location' => thumb_location
      }
      create_thumb_variant(processor_data, variant.attachment_id)
      variant.save
      return variant
    end

    # If only the variant or the thumbnail exists, or if neither exists, delete it and do the transcoding.
    if s3.buckets[bucket_name].objects[output_location].exists?
      s3.buckets[bucket_name].objects[output_location].delete
    end
    if s3.buckets[bucket_name].objects[thumb_location].exists?
      s3.buckets[bucket_name].objects[thumb_location].delete
    end

    # Send the transcoding job to S3
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
        :rotate => 'auto',
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
