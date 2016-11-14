class AbstractSubmissionSerializer < ActiveModel::Serializer

  protected

  def current_user_published?
    evaluations = current_user_evaluations
    e = evaluations.find { |e| e[0] == object.id }
    if !e.nil?
      e[2]
    else
      nil
    end
  end

  def current_user_percentage
    evaluations = current_user_evaluations
    e = evaluations.find { |e| e[0] == object.id }
    if !e.nil?
      e[1].round
    else
      nil
    end
  end

  def role
    object.course.role(scope)
  end

  def self_evaluation_percentage
    if object.evaluations.self_evaluations.count > 0
      object.evaluations.self_evaluations[0].total_percentage.round
    else
      nil
    end
  end

  def instructor_score_percentage
    if scope.role?(:administrator) || scope.role?(:evaluator)
      object.instructor_score_percentage
    else
      nil
    end
  end

  def current_user_evaluations
    Evaluation.by_course_and_evaluator(object.project.course_id, scope).pluck(:submission_id, :total_percentage, :published)
  end

  def new_posts_for_current_user?
    object.new_posts_for_user?(scope)
  end

  def abilities
    ability = Ability.new(scope)
    {
        can_own: ability.can?(:own, object),
        can_evaluate: ability.can?(:evaluate, object),
        can_attach: ability.can?(:attach, object),
        can_discuss: ability.can?(:discuss, object),
        can_annotate: ability.can?(:annotate, object),
        can_administer: ability.can?(:administer, object)
    }
  end

  # We scope the visible evaluations to the user
  def evaluations
    evaluations = object.evaluations_visible_to(scope)
    anonymous = object.project.has_anonymous_peer_review?
    unless evaluations.nil?
      ActiveModel::ArraySerializer.new(evaluations, each_serializer: EvaluationSerializer, :scope => scope, :anonymous => anonymous)
    else
      []
    end
  end

  def path
    if object.creator_type == 'Group'
      path_args = {:course_id => object.course_id, :project_id => object.project_id, :creator_id => object.creator_id}
      course_group_evaluations_path path_args
    elsif object.creator_type == 'User'
      course_user_evaluations_path :course_id => object.course_id, :project_id => object.project_id, :creator_id => object.creator_id
    end
  end

  def current_user_is_instructor
    if object.course.role(scope) == :evaluator then
      true
    else
      false
    end
  end

  def current_user_can_read_evaluations
    current_user_is_owner || current_user_is_instructor || scope.role == :administrator
  end

  def thumb
    object.thumb()
  end

  def url
    object.url()
  end

  # TODO: Revisit this, perhaps once active_model_serializers v9 is more stable.
  def evaluated_by_instructor?
    if scope.role?(:administrator) || scope.role?(:evaluator)
      object.evaluated_by_instructor?
    else
      false
    end
  end

  def peer_score_percentage
    if scope.role?(:administrator) || scope.role?(:evaluator)
      object.peer_score_percentage
    else
      0
    end
  end


end
