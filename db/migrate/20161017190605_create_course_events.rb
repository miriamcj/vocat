class CreateCourseEvents < ActiveRecord::Migration
  def change
    create_table :course_events do |t|
      t.string :event_type
      t.integer :user_id
      t.integer :course_id
      t.datetime :created_at
      t.datetime :updated_at
      t.references :loggable, polymorphic: true, index: true
    end
  end
end
