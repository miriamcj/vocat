class SubmissionSerializer < ActiveModel::Serializer
  attributes  :id, :name, :url, :thumb, :course_name, :course_name_long, :project_name,
              :course_id, :project_id, :creator_name, :creator_id, :current_user_is_owner,
              :current_user_can_evaluate, :course_department, :course_section, :course_number,
              :instructor_evaluations, :evaluations, :instructor_score_percentage, :published

  def instructor_evaluations
    ActiveModel::ArraySerializer.new(object.instructor_evaluations, :scope => scope)
  end

  def evaluations
    ActiveModel::ArraySerializer.new(object.evaluations, :scope => scope)
  end

  def current_user_can_evaluate
    Ability.new(scope).can?(:evaluate, object)
  end

  def current_user_is_owner
		scope == object.creator
  end

  def thumb
		object.thumb()
  end

  def url
    object.url()
  end

end
