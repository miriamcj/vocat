class AdjustAttachmentTable < ActiveRecord::Migration
  def change
    rename_column :attachments, :processing_error, :processor_error
    add_column :attachments, :thumb_key, :string
  end
end
