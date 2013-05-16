class BriefSubmissionSerializer < ActiveModel::Serializer
  attributes  :id, :thumb, :creator_id, :project_id, :current_user_is_owner, :instructor_score_percentage, :published, :uploaded_attachment

  def instructor_evaluations
    ActiveModel::ArraySerializer.new(object.instructor_evaluations, :scope => scope)
  end

  def evaluations
    ActiveModel::ArraySerializer.new(object.evaluations, :scope => scope)
  end

  def current_user_can_evaluate
    Ability.new(scope).can?(:evaluate, object)
  end

  def current_user_can_discuss
    Ability.new(scope).can?(:discuss, object)
  end

  def current_user_can_annotate
    Ability.new(scope).can?(:annotate, object)
  end

  def current_user_can_attach
    Ability.new(scope).can?(:attach, object)
  end

  def video_attachment_id
    object.video_attachment_id
  end

  def current_user_is_owner
		scope == object.creator
  end

  def transcoding_error
    object.transcoding_error?()
  end

  def transcoded_attachment
    object.transcoded_attachment?()
  end

  def uploaded_attachment
    object.uploaded_attachment?()
  end

  def thumb
		object.thumb()
  end

  def url
    object.url()
  end

end
