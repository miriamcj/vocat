class EvaluationSerializer < ActiveModel::Serializer
  attributes  :id,
              :submission_id,
              :current_user_is_owner,
              :published,
              :evaluator_id,
              :evaluator_name,
              :evaluator_role,
              :score,
              :total_percentage,
              :total_score,
              :points_possible,

  def current_user_is_owner
    scope.id == object.evaluator_id
  end

  def score
    object.score_detail
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
