module Attachment::Processor

  def process(attachment)
    if can_process?(attachment)
      variant = create_variant(attachment)
      variant.start_processing
      self.do_processing(variant)
      variant.save
    end
  end

  def create_variant(attachment)
    variant = Attachment::Variant.create(:attachment => attachment, :format => @output_format, :processor_name => self.class.name)
  end

  def existing_variant?(attachment)
    variant = attachment.variant_by_format(@output_format)
    !variant.nil?
  end

  def can_process?(attachment)
    return false unless @handled_formats.include?(attachment.extension)
    return false if existing_variant?(attachment)
    true
  end

end