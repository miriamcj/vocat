# == Schema Information
#
# Table name: evaluations
#
#  id               :integer          not null, primary key
#  submission_id    :integer
#  evaluator_id     :integer
#  scores           :hstore           default({}), not null
#  published        :boolean          default(FALSE)
#  rubric_id        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  total_percentage :decimal(, )      default(0.0)
#  total_score      :decimal(, )      default(0.0)
#  evaluation_type  :integer
#
# Indexes
#
#  index_evaluations_on_scores  (scores)
#

class Evaluation < ApplicationRecord

  EVALUATION_TYPE_CREATOR = 1     #  peer
  EVALUATION_TYPE_EVALUATOR = 2   # instructor

  belongs_to :evaluator, :class_name => 'User'
  has_one :user, :through => :submission, :source => :creator, :source_type => 'User'
  has_one :group, :through => :submission, :source => :creator, :source_type => 'Group'
  has_one :project, :through => :submission
  has_one :course, :through => :project
  belongs_to :submission
  belongs_to :rubric

  scope :published, -> { where(:published => true) }
  scope :created_by, ->(creator) { where(:evaluator_id => creator) }
  scope :of_type, ->(type) { where(:evaluation_type => type) }
  scope :self_evaluations, -> { joins(:submission).where("submissions.creator_id = evaluations.evaluator_id") }

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

  validates :rubric, presence: true
  validates :submission, presence: true
  validates :evaluator, presence: true
  validates :submission_id, uniqueness: {scope: :evaluator_id, message: "can only exist once per submission/evaluator"}, :on => :create

  before_save :scaffold_scores
  before_save :update_percentage
  before_save :update_total
  after_initialize :ensure_score_hash

  def creator
    group || user
  end

  def score_detail
    out = {}
    if rubric
      scores.each do |key, score|
        out[key] = {
            score: score.to_f,
            low: rubric.low_possible_for(key),
            high: rubric.high_possible_for(key),
            percentage: (score.to_f / rubric.high_possible_for(key)) * 100,
            name: rubric.field_name_for(key)
        }
      end
    end
    out
  end

  def score_ranges
    ranges = {}
    rubric.field_keys.each do |key|
      ranges[key] = {low: rubric.low_score, high: rubric.high_score}
    end
    ranges
  end

  def evaluator_role
    role = course.role(evaluator)
    role = :evaluator if role.nil? && evaluator.role?(:administrator)
    if role.nil?
      :other
    else
      role
    end
  end

  def update_percentage
    score = self.calculate_total_score
    if score
      self.total_percentage = (score / (self.rubric_high_score.to_f * self.field_count) * 100)
    else
      0
    end
  end

  def self.by_course(course)
    Evaluation.all.joins(:submission => :project).where(:projects => {:course_id => course.id}) unless course.nil?
  end

  def self.by_course_and_evaluator(course, evaluator)
    if course.is_a? Numeric then
      course_id = course
    else
      course_id = course.id
    end
    Evaluation.all.joins(:submission => :project).where(:evaluator_id => evaluator.id, :projects => {:course_id => course_id})
  end

  # TODO: This case statement masquerading as an if statement suggests
  # that we might want to consider STI for these different types of
  # evaluations, as we did for projects.
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


  # TODO: See previous method
  def evaluation_type_human_readable
    if evaluation_type == EVALUATION_TYPE_CREATOR then
      'peer'
    else
      'instructor'
    end
  end

  def update_total
    self.total_score = self.calculate_total_score
  end

  def calculate_total_score
    self.scores.values.collect { |s| s.to_i }.reduce(:+)
  end

  def active_model_serializer
    EvaluationSerializer
  end

  def ensure_score_hash
    unless self.scores.is_a?(Hash)
      self.scores = {}
    end
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

  def self.each_field_average (evaluations)
    scores = evaluations.pluck(:scores)
    count = scores.count.to_f
    fields = evaluations.last.rubric.fields
    deets = {}
    fields.each do |field|
      id = field["id"]
      deets[id] = scores.map { |e| e[id].to_i }.sum / count
    end
    return deets;
  end

  def total_percentage_rounded
    total_percentage.round(0)
  end


  def to_csv_header_row
    ['Vocat ID', 'Evaluator', 'Section', 'Course', 'Semester', 'Creator', 'Evaluation Type', 'Project Name', 'Percentage', 'Total Score', 'Points Possible']
  end

  def to_csv
    [id, evaluator_name, course.section, "#{course.department}#{course.number}", course.semester, creator.name, evaluation_type_human_readable, project.name, total_percentage_rounded, total_score, points_possible]
  end


end
