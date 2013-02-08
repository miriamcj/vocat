class RenameAssignmentSubmissionsToAttachments < ActiveRecord::Migration
  def up
    rename_table :assignment_submissions, :attachments
  end

  def down
    rename_table :attachments, :assignment_submissions
  end
end
