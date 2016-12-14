# == Schema Information
#
# Table name: discussion_posts
#
#  id            :integer          not null, primary key
#  published     :boolean
#  author_id     :integer
#  parent_id     :integer
#  body          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  submission_id :integer
#

class DiscussionPost < ApplicationRecord

  belongs_to :author, :class_name => 'User'
  belongs_to :parent, :class_name => 'DiscussionPost'
  belongs_to :submission, :counter_cache => true
  has_many :children, :class_name => 'DiscussionPost', :foreign_key => 'parent_id', :dependent => :destroy

  delegate :name, :to => :author, :prefix => true

  scope :by_course, ->(course) {
    joins(:submission => :project).where(:projects => {:course_id => course.id}) unless course.nil?
  }
  scope :in_organization, ->(organization) {
    joins(:submission => {:project => {:course => :organization}}).where('organizations.id = ?', organization.id)
  }
  scope :in_courses,  -> (courses) {
    joins(:submission => {:project => :course}).where('courses.id IN(?)', courses.pluck(:id))
  }

  def active_model_serializer
    DiscussionPostSerializer
  end

  # TODO: Refactor out of here
  def posted_on_string
    "Posted #{created_at.strftime("%b %d, %Y at %I:%M %p")}"
  end

  def self.count_by_course(course)
    DiscussionPost.joins(:submission => :project).where(:projects => {:course_id => course.id}).count()
  end


end
