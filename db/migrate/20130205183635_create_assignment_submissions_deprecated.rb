class CreateAssignmentSubmissions_DEPRECATED < ActiveRecord::Migration
  def change
    create_table :assignment_submissions do |t|
      t.string :name
      t.text :description
      t.attachment :media

      t.timestamps
    end
  end
end
