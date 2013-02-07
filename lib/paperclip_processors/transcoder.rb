module Paperclip
  class Transcoder < Processor

    # Overriden method for doing the processing
    #
    # Known instance variables are:
    #
    # +file+ - The file object to work on
    # +options+ - The options passed from the styles hash
    # +attachment+ - The actual attachment
    def make
      encoding = @options[:encoding]

      case encoding
        when :mp4
          return transcodeMP4()
        else
          return @file
      end
    end

    protected

    def transcodeMP4
      if @attachment.content_type == "video/mp4"
        return @file
      end

      # TODO handle transcoding here

      return @file
    end
  end
end