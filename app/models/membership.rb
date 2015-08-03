# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  course_id  :integer
#  role       :string
#  created_at :datetime
#  updated_at :datetime
#

class Membership < ActiveRecord::Base

  belongs_to :course
  belongs_to :user

  scope :assistants, -> { where({:role => 'assistant'}) }
  scope :evaluators, -> { where({:role => 'evaluator'}) }
  scope :creators, -> { where({:role => 'creator'}) }
  scope :in_courses,  -> (courses) {
    where('course_id IN(?)', courses.pluck(:id))
  }


  validates_presence_of :role
  validates_presence_of :course
  validates_presence_of :user

  before_validation :set_role_from_user_role

  def set_role_from_user_role
    if role.blank? && user
      role = user.role
    end
  end

end
