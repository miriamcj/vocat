class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :course_id

      t.timestamps
    end

    create_table :groups_users do |t|
      t.integer :group_id
      t.integer :user_id
    end


  end
end
