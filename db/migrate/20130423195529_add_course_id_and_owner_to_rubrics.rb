class AddCourseIdAndOwnerToRubrics < ActiveRecord::Migration
  def change
    add_column(:rubrics, :course_id, :integer)
  end
end


