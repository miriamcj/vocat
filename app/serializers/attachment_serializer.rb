class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :submission_id, :current_user_can_destroy, :state
  #, :url, :transcoding_status, :transcoding_not_started,
  #           :transcoding_error, :transcoding_unnecessary, :transcoding_busy, :transcoding_success, :is_video

  def is_video
    object.is_video?
  end

  def submission_id
    if object.fileable_type == 'Submission'
      object.fileable_id
    end
  end

  def current_user_can_destroy
    Ability.new(scope).can?(:destroy, object)
  end

end
