class CreateDiscussionPosts < ActiveRecord::Migration
  def change
    create_table :discussion_posts do |t|
      t.boolean :published
      t.integer :author_id
      t.integer :parent_id
      t.text :body
      t.integer :project_id
      t.integer :creator_id
      t.integer :group_id

      t.timestamps
    end
  end
end
