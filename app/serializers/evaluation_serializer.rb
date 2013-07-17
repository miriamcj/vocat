class EvaluationSerializer < ActiveModel::Serializer
  attributes  :id, :evaluator_id, :scores, :total_percentage, :evaluator_name, :evaluator_role, :total_percentage_rounded,
              :current_user_is_owner, :published

  def current_user_is_owner
    object.evaluator_id == scope.id
  end

  def evaluator_role
    raw = object.evaluator_role
    case raw
      when 'evaluator'
        'Instructor'
      when 'creator'
        'Student'
      else
        raw.capitalize
    end
  end

end
