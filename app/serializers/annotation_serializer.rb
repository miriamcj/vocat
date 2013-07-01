class AnnotationSerializer < ActiveModel::Serializer
  attributes :id, :attachment_id, :author_id, :body, :published, :seconds_timecode, :smpte_timecode, :author_name, :current_user_can_destroy

  def current_user_can_destroy
    Ability.new(scope).can?(:destroy, object)
  end

end
