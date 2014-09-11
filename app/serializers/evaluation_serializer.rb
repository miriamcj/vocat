class EvaluationSerializer < ActiveModel::Serializer
  attributes  :id, :evaluator_id, :scores, :total_percentage, :evaluator_name, :evaluator_role, :total_percentage_rounded,
              :current_user_is_owner, :published, :submission_id, :points_possible

  def current_user_is_owner
    scope.id == object.evaluator_id
  end

  def evaluator_role
    raw = object.evaluator_role
    case raw.downcase
      when :evaluator
        'Instructor'
      when :creator
        evaluator = User.find(object.evaluator_id)
        if evaluator.can?(:own, object.submission)
          'Creator'
        else
          'Peer'
        end
      else
        raw.to_s.capitalize
    end
  end

end
