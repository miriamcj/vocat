class EvaluationSerializer < ActiveModel::Serializer
  attributes  :id,
              :submission_id,
              :published,
              :evaluator_id,
              :evaluator_name,
              :evaluator_role,
              :scores,
              :total_percentage,
              :total_score,
              :points_possible,
              :current_user_is_evaluator,
              :abilities

  def abilities
    {
        :can_own => Ability.new(scope).can?(:own, object),
    }
  end

  def scores
    object.score_detail
  end

  def current_user_is_evaluator
    scope.id == evaluator_id
  end

  def evaluator_role
    raw = object.evaluator_role
    case raw.downcase
      when :evaluator
        'Instructor'
      when :creator
        evaluator = User.find(object.evaluator_id)
        if evaluator.can?(:own, object.submission)
          'Self'
        else
          'Peer'
        end
      else
        raw.to_s.capitalize
    end
  end

end
