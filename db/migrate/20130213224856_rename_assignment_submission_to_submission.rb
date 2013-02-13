class RenameAssignmentSubmissionToSubmission < ActiveRecord::Migration
  def up
    remove_index :assignment_submissions_attachments, :name => :submission_attachment_attachment_id_submission_id_index
    remove_index :assignment_submissions_attachments, :name => :submission_attachment_submission_id_attachment_id_index
    rename_column :assignment_submissions_attachments, :assignment_submission_id, :submission_id
    rename_table :assignment_submissions, :submissions
    rename_table :assignment_submissions_attachments, :attachments_submissions
    add_index :attachments_submissions, [:submission_id, :attachment_id]
    add_index :attachments_submissions, [:attachment_id, :submission_id]
  end

  def down
    remove_index :attachments_submissions, :column => [:submission_id, :attachment_id]
    remove_index :attachments_submissions, :column => [:attachment_id, :submission_id]
    rename_column :attachments_submissions, :submission_id, :assignment_submission_id
    rename_table :submissions, :assignment_submissions
    rename_table :attachments_submissions, :assignment_submissions_attachments
    add_index :assignment_submissions_attachments, [:assignment_submission_id, :attachment_id], :name => :submission_attachment_submission_id_attachment_id_index
    add_index :assignment_submissions_attachments, [:attachment_id, :assignment_submission_id], :name => :submission_attachment_attachment_id_submission_id_index
  end
end
