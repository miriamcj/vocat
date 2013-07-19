class RenameDiscussionPostSubmissionField < ActiveRecord::Migration
  def up
    rename_column :discussion_posts, :submision_id, :submission_id
  end

  def down
    rename_column :discussion_posts, :submission_id, :submision_id
  end
end
