# == Schema Information
#
# Table name: attachment_variants
#
#  id              :integer          not null, primary key
#  attachment_id   :integer
#  location        :string(255)
#  format          :string(255)
#  state           :string(255)
#  processor_name  :string(255)
#  processor_data  :text
#  processor_error :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Attachment::Variant < ActiveRecord::Base

  include Storable

  belongs_to :attachment
  after_destroy :destroy_file_object

  state_machine :initial => :unprocessed do
    state :unprocessed
    state :processing
    state :processed

    event :start_processing do
      transition :unprocessed => :processing
    end

    event :finish_processing do
      transition :unprocessed => :processed
      transition :processing => :processed
    end

    event :halt_processing do
      transition :processing => :unprocessed
    end
  end

  def extension
    File.extname(location).split('.').last
  end

  def processor
    processor_name.constantize.new
  end

  def has_processing_error?
    !processor_error.blank?
  end

  def processing_complete?
    return true if processed?
    return true if unprocessed? && has_processing_error?
  end

  def sibling_variant_by_format(format)
    self.attachment.variant_by_format(format)
  end

  def check_processing_state
    processor.processing_finished?(self)
  end


end
