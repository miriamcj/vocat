class AddIsLdapUserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_ldap_user, :boolean
  end
end
