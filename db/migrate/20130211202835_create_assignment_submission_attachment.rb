class CreateAssignmentSubmissionAttachment < ActiveRecord::Migration
  def up
    create_table :assignment_submission_attachment do |t|
      t.references :assignment_submission
      t.references :attachment
    end
    add_index :assignment_submission_attachment, [:assignment_submission_id, :attachment_id], :name => "submission_attachment_submission_id_attachment_id_index"
    add_index :assignment_submission_attachment, [:attachment_id, :assignment_submission_id], :name => "submission_attachment_attachment_id_submission_id_index"
  end
  def down
    drop_table :assignment_submission_attachment
  end
end
