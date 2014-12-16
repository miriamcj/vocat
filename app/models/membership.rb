class Membership < ActiveRecord::Base

  belongs_to :course
  belongs_to :user

  scope :assistants, -> { where({:role => 'assistant'})}
  scope :evaluators, -> { where({:role => 'evaluator'})}
  scope :creators, -> { where({:role => 'creator'})}

end
