class Attachment::Processor::Transcoder::Mp4

  include(Attachment::Processor::Transcoder)
  attr_accessor :format

  def initialize
    @handled_formats = Attachment::Processor::Transcoder::TRANSCODER_INPUT_FORMATS
    @output_format = 'mp4'
  end




end
