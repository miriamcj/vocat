class RemoveNameAndDescriptionFromAttachments < ActiveRecord::Migration
  def change
    remove_column :attachments, :name
    remove_column :attachments, :description
  end
end
