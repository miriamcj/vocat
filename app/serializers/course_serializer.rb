class CourseSerializer < ActiveModel::Serializer
  attributes :id, :department, :description, :name, :number, :section, :organization_id, :role, :semester_name, :year

  # Returns the role of the scoped user for this course.
  def role
    # So, scope usually equals current_user, but in some cases, it can be set to a different user.
    object.role(scope)
  end

end
