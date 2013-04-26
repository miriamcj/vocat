class Evaluation < ActiveRecord::Base
  attr_accessible :evaluator_id, :submission_id, :rubric_id, :published, :scores, :total_percentage
  belongs_to :evaluator, :class_name => 'User'
  belongs_to :submission
  belongs_to :rubric

  scope :published, where(:published => true)
  scope :created_by, lambda { |creator| where(:evaluator_id =>  creator) }

  delegate :high_score, :to => :rubric, :prefix => true
  delegate :low_score, :to => :rubric, :prefix => true

  serialize :scores, ActiveRecord::Coders::Hstore

  def active_model_serializer
    EvaluationSerializer
  end

  def total_score
    self.scores.values.collect{|s| s.to_i}.reduce(:+)
  end

  def field_count
    self.scores.count
  end

  def total_percentage
    score = self.total_score
    score / ( self.rubric_high_score.to_f * self.field_count ) * 100
  end


end
