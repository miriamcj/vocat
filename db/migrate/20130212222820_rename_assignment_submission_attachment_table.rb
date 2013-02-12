class RenameAssignmentSubmissionAttachmentTable < ActiveRecord::Migration
  def up
    rename_table :assignment_submission_attachment, :assignment_submissions_attachments
  end
end
