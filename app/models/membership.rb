class Membership < ActiveRecord::Base

  belongs_to :course
  belongs_to :user

  scope :assistants, -> { where({:role => 'assistant'})}
  scope :evaluators, -> { where({:role => 'evaluator'})}
  scope :creators, -> { where({:role => 'creator'})}

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
