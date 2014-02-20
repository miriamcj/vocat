class AddVideoIdToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :video_id, :integer
  end
end
