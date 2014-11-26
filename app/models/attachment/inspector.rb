class Attachment::Inspector

  TYPES = {
    :audio => %w[mp3],
    :image => %w[gif jpg jpeg png],
    :video => %w[avi mp4 m4v mov flv wmv mov]

  }

  def self.attachmentToType(attachment)
    Attachment::Inspector::extensionToType(attachment.extension)
  end

  protected

  def self.extensionToType(extension)
    extension = extension.downcase.gsub('.','')
    type = :unknown
    TYPES.each do |key, extensions|
      if extensions.include? extension
        type = key
        next
      end
    end
    type
  end

end
