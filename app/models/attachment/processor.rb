module Attachment::Processor

  def process(attachment)
    if can_process?(attachment)
      variant = create_variant(attachment.id)
      variant.start_processing
      self.do_processing(variant)
      variant.save
    end
  end

  def create_variant(attachment_id)
    Attachment::Variant.find_or_create_by(:attachment_id => attachment_id, :format => @output_format, :processor_name => self.class.name)
  end

  def existing_variant?(attachment_id)
    variant = Attachment::Variant.where(:attachment_id => attachment_id, :format => @output_format).first
    !variant.nil?
  end

  def can_process?(attachment)
    return false unless @handled_formats.include?(attachment.extension)
    return true
  end

end
