class Attachment::Processor::Transcoder::Webm

  include(Attachment::Processor::Transcoder)
  attr_accessor :format

  def initialize
    @handled_formats = Attachment::Inspector.extensions_for([:video])
    @output_format = 'webm'
  end

end
