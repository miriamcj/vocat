class AdjustGroupsUsersJoinTable < ActiveRecord::Migration
  def up
    rename_table :groups_users, :groups_creators
    remove_column :groups_creators, :id
  end

  def down
    rename_table :groups_creators, :groups_users
    add_column :groups_users, :id, :primary_key
  end
end
