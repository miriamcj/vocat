class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :department
      t.string :number
      t.string :section
      t.text :description
      t.references :organization

      t.timestamps
    end
    add_index :courses, :organization_id
  end
end
