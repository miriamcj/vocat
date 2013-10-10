class VideoSerializer < ActiveModel::Serializer
  attributes :id,
             :submission_id,
             :source,
             :source_id,
             :attachment_url,
             :thumb,
             :attachment_transcoding_status,
             :attachment_transcoding_error,
             :state

  def attachment_transcoding_status
    object.attachment_transcoding_status
  end

  def thumb
    object.thumb
  end

end
