require 'action_view'
include ActionView::Helpers::NumberHelper

class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :current_user_can_destroy, :state, :s3_upload_document, :size, :extension, :bucket, :bucket_public_key

  def bucket
    Rails.application.config.vocat.aws[:s3_bucket]
  end

  def bucket_public_key
    Rails.application.config.vocat.aws[:key]
  end

  def s3_upload_document
    if object.committed?
      null
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
