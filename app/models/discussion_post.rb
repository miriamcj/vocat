class DiscussionPost < ActiveRecord::Base

  belongs_to :author, :class_name => "User"

  attr_accessible :author_id, :body, :creator_id, :group_id, :parent_id, :project_id, :published

  scope :for_submission, lambda { |submission| where('creator_id' => submission.creator_id, 'project_id' => submission.project_id) }

  delegate :name, :to => :author, :prefix => true

  def active_model_serializer
    DiscussionPostSerializer
  end

end
