class RemoveTranscodingCompleteColumnFromAssignmentSubmissions < ActiveRecord::Migration
  def up
    remove_column :assignment_submissions, :transcoding_complete
  end

  def down
    add_column :assignment_submissions, :transcoding_complete, :boolean
  end
end
