# == Schema Information
#
# Table name: course_events
#
#  id            :integer          not null, primary key
#  event_type    :string
#  user_id       :integer
#  course_id     :integer
#  created_at    :datetime
#  updated_at    :datetime
#  loggable_id   :integer
#  loggable_type :string
#  submission_id :integer
#
# Indexes
#
#  index_course_events_on_loggable_type_and_loggable_id  (loggable_type,loggable_id)
#

class CourseEvent < ApplicationRecord

  belongs_to :loggable, polymorphic: true

  scope :non_destructive, -> { where("event_type = ? OR event_type = ?", 'create', 'update') }
  scope :discussion_posts, -> { where("loggable_type = ?", 'DiscussionPost') }
  scope :annotations, -> { where("loggable_type = ?", 'Annotation') }

  validates :user_id, :loggable_id, :loggable_type, :course_id, :event_type, presence: true
  validates :submission_id, presence: true if :require_submission_id

  def require_submission_id
    loggable_type == 'DiscussionPost' || loggable_type == 'Annotation'
  end

end
