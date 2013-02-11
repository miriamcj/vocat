class CreateAssignmentSubmissions < ActiveRecord::Migration
  def change
    create_table :assignment_submissions do |t|
      t.string :name
      t.text :summary

      t.timestamps
    end
  end
end
