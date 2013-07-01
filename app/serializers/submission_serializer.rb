class SubmissionSerializer < ActiveModel::Serializer
  attributes  :id, :name, :url, :thumb, :course_name, :course_name_long, :project_name,
              :course_id, :project_id, :creator_name, :creator_id, :current_user_is_owner,
              :current_user_can_evaluate, :course_department, :course_section, :course_number,
              :instructor_evaluations, :evaluations, :instructor_score_percentage, :published,
              :attachment, :current_user_can_annotate, :current_user_can_attach, :current_user_can_discuss,
              :scored_by_instructor?, :path

  has_one :attachment

  def path
    if Ability.new(scope).can?(:evaluate, object)
      course_evaluations_path :course_id => object.course_id, :project_id => object.project_id, :creator_id => object.creator_id
    else
      course_creator_and_project_path :course_id => object.course_id, :project_id => object.project_id, :creator_id => object.creator_id
    end
  end

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

  def has_transcoding_error
    object.transcoding_error?()
  end

  def transcoding_in_progress
    object.transcoding_in_progress?
  end

  def is_transcoding_complete
    object.transcoding_complete?
  end


  def has_transcoded_attachment
    object.transcoded_attachment?()
  end

  def has_uploaded_attachment
    object.uploaded_attachment?()
  end

  def is_video
    object.attachment && object.attachment.is_video?
  end

  def thumb
		object.thumb()
  end

  def url
    object.url()
  end

end
