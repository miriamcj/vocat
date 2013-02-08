class AddTranscodingStatusAndTranscodingErrorToAssignmentSubmissions < ActiveRecord::Migration
  def change
    add_column :assignment_submissions, :transcoding_status, :integer, :default => 0
    add_column :assignment_submissions, :transcoding_error, :string
  end
end
