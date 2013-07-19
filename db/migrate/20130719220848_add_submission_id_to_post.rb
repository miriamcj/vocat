class AddSubmissionIdToPost < ActiveRecord::Migration
  def change
    remove_column :discussion_posts, :project_id
    remove_column :discussion_posts, :creator_id
    remove_column :discussion_posts, :group_id
    add_column :discussion_posts, :submision_id, :integer
  end
end
