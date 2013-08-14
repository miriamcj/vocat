class SubmissionSerializer < ActiveModel::Serializer

  attributes  :id, :name, :url, :thumb, :course_name, :course_name_long, :course_allows_peer_review, :course_allows_self_evaluation,
              :project_name, :course_id, :project_id, :creator_name, :creator_id, :current_user_is_owner,
              :current_user_can_evaluate, :course_department, :course_section, :course_number,
              :evaluations, :current_user_percentage, :current_user_evaluation_published?, :current_user_has_evaluated?,
              :current_user_can_annotate, :current_user_can_attach, :current_user_can_discuss, :attachment, :video,
              :has_video?, :path, :peer_score_percentage, :instructor_score_percentage, :current_user_is_instructor, :discussion_posts_count

  # This makes sure that the correct serializer is used for the child association.
  has_one :attachment

  def path
    if Ability.new(scope).can?(:evaluate, object)
      course_evaluations_path :course_id => object.course_id, :project_id => object.project_id, :creator_id => object.creator_id
    else
      course_creator_and_project_path :course_id => object.course_id, :project_id => object.project_id, :creator_id => object.creator_id
    end
  end

  def current_user_percentage
    object.user_score_percentage(scope)
  end

  def current_user_has_evaluated?
    object.evaluated_by_user?(scope)
  end

  def current_user_evaluation_published?
    object.user_evaluation_published?(scope)
  end

  def evaluations
    ActiveModel::ArraySerializer.new(object.evaluations_visible_to(scope), :scope => scope)
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

  def current_user_is_owner
		scope == object.creator
  end

  def current_user_is_instructor
    if object.course.role(scope) == :evaluator then true else false end
  end


  def thumb
		object.thumb()
  end

  def url
    object.url()
  end

end
