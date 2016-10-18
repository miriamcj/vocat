# == Schema Information
#
# Table name: visits
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  visitable_course_id :integer
#  visitable_id        :integer
#  visitable_type      :string
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  index_visits_on_visitable_course_id              (visitable_course_id)
#  index_visits_on_visitable_type_and_visitable_id  (visitable_type,visitable_id)
#

class Visit < ActiveRecord::Base

  belongs_to :visitable, polymorphic: true

  validates :user_id, :visitable_id, :visitable_type, presence: true

  scope :most_recent, -> { order(updated_at: :desc).first }

end
