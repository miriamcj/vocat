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
#
# Indexes
#
#  index_course_events_on_loggable_type_and_loggable_id  (loggable_type,loggable_id)
#

class CourseEvent < ActiveRecord::Base

  belongs_to :loggable, polymorphic: true

  scope :non_destructive, -> { where("event_type = ? OR event_type = ?", 'create', 'update') }

  validates :user_id, :loggable_id, :loggable_type, :course_id, :event_type, presence: true

end
