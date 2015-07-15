# == Schema Information
#
# Table name: projects
#
#  id                          :integer          not null, primary key
#  name                        :string(255)
#  description                 :text
#  course_id                   :integer
#  project_type_id             :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  rubric_id                   :integer
#  listing_order               :integer
#  type                        :string(255)      default("user")
#  due_date                    :date
#  allowed_attachment_families :text             default([]), is an Array
#  settings                    :hstore           default({}), not null
#
# Indexes
#
#  index_projects_on_course_id        (course_id)
#  index_projects_on_project_type_id  (project_type_id)
#

class OpenProject < Project

  def type_human()
    'groups and students'
  end

  def accepts_group_submissions?
    true
  end

  def accepts_user_submissions?
    true
  end

end
