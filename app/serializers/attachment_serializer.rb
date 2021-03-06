# == Schema Information
#
# Table name: attachments
#
#  id                  :integer          not null, primary key
#  media_file_name     :string
#  media_content_type  :string
#  media_file_size     :integer
#  media_updated_at    :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  state               :string
#  processor_error     :string
#  user_id             :integer
#  processed_key       :string
#  processor_job_id    :string
#  processor_class     :string
#  processed_thumb_key :string
#  processing_data     :hstore
#  asset_id            :integer
#

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
