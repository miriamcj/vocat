# == Schema Information
#
# Table name: projects
#
#  id                          :integer          not null, primary key
#  name                        :string
#  description                 :text
#  course_id                   :integer
#  project_type_id             :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  rubric_id                   :integer
#  listing_order               :integer
#  type                        :string           default("user")
#  due_date                    :date
#  allowed_attachment_families :text             default([]), is an Array
#  settings                    :hstore           default({}), not null
#
# Indexes
#
#  index_projects_on_course_id        (course_id)
#  index_projects_on_project_type_id  (project_type_id)
#

class GroupProject < Project

  def type_human()
    'groups'
  end

  def accepts_group_submissions?
    true
  end

  def accepts_user_submissions?
    false
  end

end
