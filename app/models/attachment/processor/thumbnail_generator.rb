class Attachment::Processor::ThumbnailGenerator

  include(Attachment::Processor)

  RESIZER_INPUT_FORMATS = []

  def do_processing(variant)
    attachment = variant.attachment
    output_location = "processed/attachment/#{attachment.path_segment}/#{attachment.id}_thumb.#{@output_format}"
    variant.processor_data = ActiveSupport::JSON.encode({completed: false})
    variant.location = output_location
    variant.format = 'jpg_thumb'
    variant.save
    ThumbnailWorker.perform_in(2.seconds, variant.id, output_location)
    variant
  end

  def processing_finished?(variant)
    return false if variant.processor_data.nil?
    parsed_processor_data = ActiveSupport::JSON.decode(variant.processor_data)
    parsed_processor_data[:completed]
  end

  def initialize
    @handled_formats = Attachment::Inspector.extensions_for([:image])
    @output_format = "jpg"
  end

  protected


end
