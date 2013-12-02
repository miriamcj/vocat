class AddOrgIdentityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :org_identity, :string
  end
end
