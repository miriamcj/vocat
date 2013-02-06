module Paperclip
  class Transcoder < Processor

    def initialize(file, options = {}, attachment = nil)
      @file = file
      @options = options
      @attachment = attachment
    end

    def make
      return @file
    end
  end
end