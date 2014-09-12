class AbstractSubmissionSerializer < ActiveModel::Serializer

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

	def current_user_evaluation
		object.user_evaluation(scope)
	end

  def course_allows_peer_review
    object.course_allows_peer_review?
  end

  def course_allows_self_evaluation
    object.course_allows_self_evaluation?
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
    evaluations = object.evaluations_visible_to(scope)
    unless evaluations.nil?
      ActiveModel::ArraySerializer.new(evaluations, each_serializer: EvaluationSerializer, :scope => scope)
    else
      []
    end
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
    Ability.new(scope).can?(:own, object)
	end

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

end