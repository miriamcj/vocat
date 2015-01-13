class AnnotationSerializer < ActiveModel::Serializer
  attributes :id, :asset_id, :author_id, :body, :published, :seconds_timecode, :smpte_timecode, :author_name,
             :current_user_can_destroy, :current_user_can_edit, :gravatar, :author_role

  def current_user_can_destroy
    Ability.new(scope).can?(:destroy, object)
  end

  def current_user_can_edit
    Ability.new(scope).can?(:update, object)
  end

  def author_role
    if author_id == scope.id
      'self'
    else
      # Ugh.
      course = object.asset.submission.course
      course.role(object.author)
    end
  end

  def gravatar
    gravatar_id = Digest::MD5.hexdigest(object.author.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=mm&s="
  end

end
