class AddTranscodingCompleteColumnToAssignmentSubmissions < ActiveRecord::Migration
  def change
    add_column :assignment_submissions, :transcoding_complete, :boolean
  end
end
