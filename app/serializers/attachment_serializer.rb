require 'action_view'
include ActionView::Helpers::NumberHelper

class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :current_user_can_destroy, :state, :s3_upload_document, :size, :extension

  def s3_upload_document
    if object.committed?
      nil
    else
      object.s3_upload_document
    end
  end

  def extension
    object.extension.gsub('.', '')
  end

  def current_user_can_destroy
    Ability.new(scope).can?(:destroy, object)
  end

end
