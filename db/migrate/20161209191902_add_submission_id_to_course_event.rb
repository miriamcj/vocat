class AddSubmissionIdToCourseEvent < ActiveRecord::Migration
  def change
    add_column :course_events, :submission_id, :integer
  end
end
