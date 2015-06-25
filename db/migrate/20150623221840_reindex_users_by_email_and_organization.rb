class ReindexUsersByEmailAndOrganization < ActiveRecord::Migration
  def change
    remove_index :users, :email
    add_index :users, [:email, :organization_id], :unique => true
  end
end
