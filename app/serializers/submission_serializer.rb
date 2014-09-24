class SubmissionSerializer < AbstractSubmissionSerializer

  attributes  :id,
              :name,
              :path,
              :serialized_state,
              :path,
              :role,
              :discussion_posts_count,
              :project,
              :creator,
              :creator_id,
              :creator_type,
              :project_id,
              :evaluations,
              :video,
              :abilities

  has_one :project
  has_one :creator
  has_one :video

  protected

  def abilities
    {
        can_own: Ability.new(scope).can?(:own, object),
        can_evaluate: Ability.new(scope).can?(:evaluate, object),
        can_attach: Ability.new(scope).can?(:attach, object),
        can_discuss: Ability.new(scope).can?(:discuss, object),
        can_annotate:  Ability.new(scope).can?(:annotate, object)
    }
  end

  def role
    object.course.role(scope)
  end

  # We scope the visible evaluations to the user
  def evaluations
    evaluations = object.evaluations_visible_to(scope)
    unless evaluations.nil?
      ActiveModel::ArraySerializer.new(evaluations, each_serializer: EvaluationSerializer, :scope => scope)
    else
      []
    end
  end

  def path
    if object.creator_id == scope.id
      course_current_user_project_path :course_id => object.course_id, :project_id => object.project_id
    else
      if object.creator_type == 'Group'
        path_args = {:course_id => object.course_id, :project_id => object.project_id, :creator_id => object.creator_id}
        course_group_evaluations_path path_args
      elsif object.creator_type == 'User'
        course_user_evaluations_path :course_id => object.course_id, :project_id => object.project_id, :creator_id => object.creator_id
      end
    end
  end



	def serialized_state
		'full'
  end

  protected


  def current_user_is_instructor
    if object.course.role(scope) == :evaluator then true else false end
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


  def instructor_score_percentage
    if scope.role?(:administrator) || scope.role?(:evaluator)
      object.instructor_score_percentage
    else
      0
    end
  end



end
