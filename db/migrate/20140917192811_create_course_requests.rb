class CreateCourseRequests < ActiveRecord::Migration
  def change
    create_table :course_requests do |t|
      t.string :name
      t.string :department
      t.string :section
      t.string :number
      t.integer :year
      t.integer :semester_id
      t.integer :evaluator_id
      t.string :state
      t.integer :admin_id
      t.integer :course_id

      t.timestamps
    end
  end
end
