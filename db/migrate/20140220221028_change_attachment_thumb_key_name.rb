class ChangeAttachmentThumbKeyName < ActiveRecord::Migration
  def change
    rename_column :attachments, :thumb_key, :processed_thumb_key
  end
end
