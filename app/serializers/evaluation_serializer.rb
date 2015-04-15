class EvaluationSerializer < ActiveModel::Serializer
  attributes :id,
             :submission_id,
             :published,
             :evaluator_id,
             :evaluator_name,
             :evaluator_role,
             :scores,
             :score_details,
             :total_percentage,
             :total_score,
             :points_possible,
             :current_user_is_evaluator,
             :abilities


  def evaluator_name
    if should_anonymize_evaluation
      'anonymous'
    else
      object.evaluator_name
    end
  end

  def evaluator_id
    if should_anonymize_evaluation
      nil
    else
      object.evaluator_id
    end
  end


  def abilities
    {
        :can_own => Ability.new(scope).can?(:own, object),
    }
  end

  def score_details
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

  private

  def should_anonymize_evaluation
    @options.key?(:anonymous) &&
        @options[:anonymous] == true &&
        Ability.new(scope).cannot?(:administer, object.submission.project.course) &&
        scope.id != object.evaluator_id
  end

end
