class CreateCourseRequests < ActiveRecord::Migration
  def change
    create_table :course_requests do |t|
      t.string :name
      t.string :department
      t.string :section
      t.string :number
      t.integer :year
      t.integer :semester
      t.integer :requestor_id
      t.integer :state
      t.integer :admin_id
      t.integer :course_id

      t.timestamps
    end
  end
end
