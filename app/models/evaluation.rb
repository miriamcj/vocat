class Evaluation < ActiveRecord::Base

  EVALUATION_TYPE_CREATOR = 1
  EVALUATION_TYPE_EVALUATOR = 2

  belongs_to :evaluator, :class_name => 'User'
  has_one :user, :through => :submission, :source => :creator, :source_type => 'User'
  has_one :group, :through => :submission, :source => :creator, :source_type => 'Group'
  has_one :project, :through => :submission
  belongs_to :submission
  belongs_to :rubric

  scope :published, -> { where(:published => true) }
  scope :created_by, -> (creator) {
    where(:evaluator_id =>  creator)
  }

  before_save { |evaluation|
    if evaluator.role?(:creator)
      evaluation.evaluation_type = EVALUATION_TYPE_CREATOR
    else
      evaluation.evaluation_type = EVALUATION_TYPE_EVALUATOR
    end
  }

  delegate :high_score, :to => :rubric, :prefix => true, :allow_nil => true
  delegate :low_score, :to => :rubric, :prefix => true, :allow_nil => true
  delegate :points_possible, :to => :rubric, :allow_nil => true
  delegate :name, :to => :evaluator, :prefix => true
  delegate :role, :to => :evaluator, :prefix => true

  validates :rubric, presence: true
  validates :submission, presence: true
  validates :evaluator, presence: true
  validates :submission_id, uniqueness: { scope: :evaluator_id, message: "can only exist once per submission/evaluator" }, :on => :create

  before_save :scaffold_scores
  before_save :update_percentage
  before_save :update_total
  after_initialize :ensure_score_hash


  def creator
    group || user
  end

  def ensure_score_hash
    unless self.scores.is_a?(Hash)
      self.scores = {}
    end
  end

  def update_percentage
    score = self.calculate_total_score
    if score
      self.total_percentage = (score / ( self.rubric_high_score.to_f * self.field_count ) * 100)
    else
      0
    end
  end

  def self.by_course(course)
    Evaluation.all.joins(:submission => :project).where(:projects => {:course_id => course.id}) unless course.nil?
  end

  def self.average_score_by_course_and_type(course, type)
    if type == :creator
      type = EVALUATION_TYPE_CREATOR
    elsif type == :evaluator || type == :assistant
      type = EVALUATION_TYPE_EVALUATOR
    else
      type = EVALUATION_TYPE_EVALUATOR
    end

    evaluations = Evaluation.joins(:submission => :project).where(:evaluation_type => type, :projects => {:course_id => course.id}).all unless course.nil?
    total = evaluations.reduce(0.0) do |memo, evaluation|
      memo + evaluation.total_percentage_rounded
    end
    evaluations_count = evaluations.length
    if evaluations_count > 0
      (total / evaluations_count).round(0)
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

  def scaffold_scores
    scores_will_change!
    rubric.field_keys.each do |key|
      unless scores.has_key? key
        scores[key] = rubric.low
      end
    end
  end

  def field_count
    self.scores.count
  end

  def total_percentage_rounded
    total_percentage.round(0)
  end

  def to_csv_header_row
    ['Vocat ID', 'Evaluator', 'Creator', 'Type', 'Project Name', 'Percentage', 'Total Score', 'Points Possible']
  end

  def to_csv
    [id, evaluator_name, creator.name, evaluation_type, project.name, total_percentage_rounded, total_score, points_possible]
  end

end
