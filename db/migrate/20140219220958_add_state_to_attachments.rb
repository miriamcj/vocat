class AddStateToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :state, :string
  end
end
