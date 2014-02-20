class AddProcessedKeyToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :processed_key, :string
  end
end
