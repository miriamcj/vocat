# == Schema Information
#
# Table name: courses
#
#  id              :integer          not null, primary key
#  name            :string
#  department      :string
#  number          :string
#  section         :string
#  description     :text
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  message         :text
#  semester_id     :integer
#  year            :integer
#
# Indexes
#
#  index_courses_on_organization_id  (organization_id)
#

class CourseSerializer < ActiveModel::Serializer
  attributes :id, :department, :description, :name, :number, :section, :organization_id, :role, :semester_name, :year

  # Returns the role of the scoped user for this course.
  def role
    # So, scope usually equals current_user, but in some cases, it can be set to a different user.
    object.role(scope)
  end

end
