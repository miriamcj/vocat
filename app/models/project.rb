class Project < ActiveRecord::Base

  include RankedModel
  ranks :listing_order, :with_same => :course_id

  belongs_to  :course
  belongs_to  :rubric
  has_many    :submissions,     :dependent => :destroy
  has_many    :submitors,       :through => :course
  has_many    :evaluations,     :through => :submissions

  delegate :name,               :to => :rubric, :prefix => true, :allow_nil => true
  delegate :avg_score,          :to => :rubric, :prefix => true, :allow_nil => true
  delegate :avg_percentage,     :to => :rubric, :prefix => true, :allow_nil => true

  delegate :department,         :to => :course, :prefix => true
  delegate :number,             :to => :course, :prefix => true
  delegate :name,               :to => :course, :prefix => true
  delegate :section,            :to => :course, :prefix => true
  delegate :name_long,          :to => :course, :prefix => true
  delegate :id,                 :to => :course, :prefix => true
  delegate :allows_peer_review, :to => :course

  validates :course, :name, :description, :presence => true

  default_scope { includes(:course) }

  scope :unsubmitted_for_user_and_course, -> (creator, course) { joins('LEFT OUTER JOIN submissions ON submissions.project_id = projects.id AND submissions.creator_id = ' + creator.id.to_s).where('submissions.creator_id IS NULL AND course_id IN (?)', course) }

  def active_model_serializer
    ProjectSerializer
  end

  def published_evaluations_by_type(type)
    evaluations.published.of_type(type).includes(:submission)
  end

  def published_evaluations_by_evaluator(user)
    evaluations.published.created_by(user).includes(:submission)
  end

  def published_evaluations
    evaluations.where(published: true).includes(:submission)
  end

  def evaluation_count_by_user(user)
    Evaluation.joins(:submission).where(:evaluator_id => user, :submissions => {project_id: self}).count
  end

  def avg_score()
    Evaluation.includes(:project).where(projects: {id: self}).average('total_score') || 0
  end

  def avg_percentage()
    Evaluation.includes(:project).where(projects: {id: self}).average('total_percentage') || 0
  end

  # TODO: Not happy with this
  def statistics()
    {
      video_count: submissions.with_video.count,
      possible_submission_count: possible_submissions_count,
      rubric_avg_score: rubric_avg_score,
      rubric_avg_percentage: rubric_avg_percentage
    }
  end

  def submission_by_user(user)
    submissions.where(:creator_id => user.id).first
  end

  def evaluatable()
    !rubric.nil?
  end

  def to_s()
    self.name
  end

  def possible_submissions_count
    Course.count_possible_submissions_for(self)
  end

  def type_human()
    raise NotImplementedError
  end

  def accepts_group_submissions?
    raise NotImplementedError
  end

  def accepts_user_submissions?
    raise NotImplementedError
  end

end
