class Evaluation < ActiveRecord::Base
  attr_accessible :evaluator_id, :submission_id, :rubric_id, :published, :scores, :total_percentage, :total_score
  belongs_to :evaluator, :class_name => 'User'
  has_one :creator, :through => :submission
  has_one :project, :through => :submission
  belongs_to :submission
  belongs_to :rubric

  scope :published, where(:published => true)
  scope :created_by, lambda { |creator| where(:evaluator_id =>  creator) }

  delegate :high_score, :to => :rubric, :prefix => true
  delegate :low_score, :to => :rubric, :prefix => true
  delegate :name, :to => :evaluator, :prefix => true
  delegate :role, :to => :evaluator, :prefix => true
  delegate :points_possible, :to => :rubric

  validates :rubric, presence: true
  validates :submission, presence: true
  validates :evaluator, presence: true
  validates :submission_id, uniqueness: { scope: :evaluator_id, message: "can only exist once per submission/evaluator" }, :on => :create

  before_save :scaffold_score
  before_save :update_percentage
  before_save :update_total

  serialize :scores, ActiveRecord::Coders::Hstore

  def update_percentage
    score = self.calculate_total_score
    if score
      self.total_percentage = (score / ( self.rubric_high_score.to_f * self.field_count ) * 100)
    else
      0
    end
  end

  def update_total
    self.total_score = self.calculate_total_score
  end

  def calculate_total_score
    self.scores.values.collect{|s| s.to_i}.reduce(:+)
  end

  def active_model_serializer
    EvaluationSerializer
  end

  def scaffold_score
    rubric.field_keys.each do |key|
      unless scores.has_key? key
        scores[key] = 0
      end
    end
  end


  def field_count
    self.scores.count
  end

  def total_percentage_rounded
    total_percentage.round(0)
  end


end
