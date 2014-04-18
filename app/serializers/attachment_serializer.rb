class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :video_id, :current_user_can_destroy, :state

  def is_video
    object.is_video?
  end

  def current_user_can_destroy
    Ability.new(scope).can?(:destroy, object)
  end

end
