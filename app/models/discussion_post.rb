class DiscussionPost < ActiveRecord::Base

  belongs_to :author, :class_name => 'User'
  belongs_to :parent, :class_name => 'DiscussionPost'
  belongs_to :submission
  has_many :children, :class_name => 'DiscussionPost', :foreign_key => 'parent_id', :dependent => :destroy

  attr_accessible :author_id, :body, :parent_id, :submission_id, :published

  delegate :name, :to => :author, :prefix => true

  def active_model_serializer
    DiscussionPostSerializer
  end

end
