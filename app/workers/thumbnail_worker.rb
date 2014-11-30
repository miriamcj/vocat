class ThumbnailWorker

  include Sidekiq::Worker

  def perform(variant_id, output_location, size)
    variant = Attachment::Variant.find(variant_id)
    if variant.processing?
      attachment = variant.attachment
      input_location = attachment.public_location
      image = MiniMagick::Image.open(input_location)
      image.resize size
      image.format "jpg"
      s3 = variant.get_s3_instance
      s3.buckets[variant.bucket].objects[output_location].write(:file => image.path)
      processor_data = {
        completed: true
      }
      variant.processor_data = ActiveSupport::JSON.encode(processor_data)
      variant.finish_processing
      variant.save
    end
  end

end
