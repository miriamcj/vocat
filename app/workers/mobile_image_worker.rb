class MobileImageWorker

  include Sidekiq::Worker

  def perform(variant_id, output_location)
    variant = Attachment::Variant.find(variant_id)
    if variant.processing?
      attachment = variant.attachment
      input_location = attachment.public_location
      MiniMagick.configure do |config|
        config.whiny = false
      end
      image = MiniMagick::Image.open(input_location)
      image.format "jpeg"
      if image[:width].to_f > 500 || image[:width].to_f > 500
        image.resize "500x500"
      end
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
