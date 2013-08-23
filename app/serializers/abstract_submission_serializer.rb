class AbstractSubmissionSerializer < ActiveModel::Serializer

	def path
		path_args = {:course_id => object.course_id, :project_id => object.project_id, :creator_id => object.creator_id}
		if object.creator_type == 'Group'
			course_group_evaluations_path path_args
		elsif object.creator_type == 'User'
			course_user_evaluations_path :course_id => object.course_id, :project_id => object.project_id, :creator_id => object.creator_id
		end
	end

	def current_user_evaluation
		object.user_evaluation(scope)
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