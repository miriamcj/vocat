class ChangeAttachmentAssociations < ActiveRecord::Migration
  def up
    drop_table :attachments_submissions

    add_column :attachments, :fileable_id, :integer
    add_column :attachments, :fileable_type, :string
    add_index :attachments, [:fileable_id, :fileable_type]
  end

  def down
    create_table :attachments_submissions do |t|
      t.references :submission
      t.references :attachment
    end
    add_index :attachments_submissions, [:submission_id, :attachment_id]
    add_index :attachments_submissions, [:attachment_id, :submission_id]
  end
end
