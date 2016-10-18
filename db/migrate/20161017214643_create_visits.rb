class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :user_id
      t.integer :visitable_course_id
      t.references :visitable, polymorphic: true, index: true
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index "visits", ["visitable_course_id"], :name => "index_visits_on_visitable_course_id"
  end
end
