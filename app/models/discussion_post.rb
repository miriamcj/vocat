class DiscussionPost < ActiveRecord::Base
  attr_accessible :author_id, :body, :creator_id, :group_id, :parent_id, :project_id, :published
end
