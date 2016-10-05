class AbstractSubmissionSerializer < ActiveModel::Serializer

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
      e[1]
    else
      nil
    end
  end

  def role
    object.course.role(scope)
  end

  def instructor_score_percentage
    if scope.role?(:administrator) || scope.role?(:evaluator)
      object.instructor_score_percentage
    else
      nil
    end
  end

  protected

  def current_user_evaluations
    Evaluation.by_course_and_evaluator(object.project.course_id, scope).pluck(:submission_id, :total_percentage, :published)
  end


end
