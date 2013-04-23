class Evaluation < ActiveRecord::Base
  attr_accessible :evaluator_id, :submission_id, :rubric_id, :published, :scores
  belongs_to :evaluator, :class_name => 'User'
  belongs_to :submission
  belongs_to :rubric


end
