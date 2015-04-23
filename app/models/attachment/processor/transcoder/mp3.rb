class Attachment::Processor::Transcoder::Mp3

  include(Attachment::Processor::Transcoder)
  attr_accessor :format

  def initialize
    @handled_formats = Attachment::Inspector.extensions_for([:audio])
    @output_format = 'mp3'
  end

  def can_generate_thumbnail?()
    false
  end


end
