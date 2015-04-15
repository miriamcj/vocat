class Attachment::Inspector

  TYPES = {
      :audio => %w[mp3],
      :image => %w[gif jpg jpeg png tif tiff],
      :video => %w[avi mp4 m4v mov flv wmv webm ogv mkv]
  }

  MIME_TYPES = {
      :audio => %w[audio/mp3],
      :image => %w[image/gif image/jpg image/jpeg image/png image/tiff],
      :video => %w[video/x-msvideo video/mp4 video/x-m4v quicktime/mov video/x-flv video/x-ms-wmv video/webm, video/ogg, video/divx]
  }

  def self.attachmentToType(attachment)
    Attachment::Inspector::extensionToType(attachment.extension)
  end

  def self.extensions_for(families)
    if families.empty?
      TYPES.values.flatten.uniq
    else
      families.map { |family| TYPES[family.to_sym] }.flatten.uniq
    end
  end

  def self.mime_types_for(families)
    if families.empty?
      MIME_TYPES.values.flatten.uniq
    else
      families.map { |family| MIME_TYPES[family.to_sym] }.flatten.uniq
    end
  end


  protected

  def self.extensionToType(extension)
    extension = extension.downcase.gsub('.', '')
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
