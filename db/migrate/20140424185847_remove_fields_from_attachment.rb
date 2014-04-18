class RemoveFieldsFromAttachment < ActiveRecord::Migration
  def change
    remove_column :attachments, :fileable_id
    remove_column :attachments, :fileable_type
    remove_column :attachments, :transcoding_error
    remove_column :attachments, :transcoding_status
  end
end
