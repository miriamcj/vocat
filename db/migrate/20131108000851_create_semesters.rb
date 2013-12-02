class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.string :name
      t.integer :position
      t.timestamps
    end
    remove_column :courses, :year
    remove_column :courses, :semester
  end
end
