class Attachment::Processor::Transcoder::Webm

  include(Attachment::Processor::Transcoder)
  attr_accessor :format

  def initialize
    @handled_formats = Attachment::Processor::Transcoder::TRANSCODER_INPUT_FORMATS
    @output_format = 'webm'
  end

end
