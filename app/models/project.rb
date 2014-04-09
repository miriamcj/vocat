class Project < ActiveRecord::Base

  include RankedModel
  ranks :listing_order, :with_same => :course_id

  belongs_to :course
  belongs_to :rubric
  has_many :submissions, :dependent => :destroy
  has_many :submitors, :through => :course
  has_many :evaluations, :through => :submissions

  delegate :name, :to => :rubric, :prefix => true, :allow_nil => true
  delegate :department, :to => :course, :prefix => true
  delegate :number, :to => :course, :prefix => true
  delegate :name, :to => :course, :prefix => true
  delegate :section, :to => :course, :prefix => true
  delegate :name_long, :to => :course, :prefix => true
  delegate :id, :to => :course, :prefix => true

  PROJECT_TYPE_OPTIONS = ['group', 'user', 'any']

  validates_inclusion_of :project_type, :in => PROJECT_TYPE_OPTIONS
  validates :name, :description, :presence => true

  scope :unsubmitted_for_user_and_course, -> (creator, course) { joins('LEFT OUTER JOIN submissions ON submissions.project_id = projects.id AND submissions.creator_id = ' + creator.id.to_s).where('submissions.creator_id IS NULL AND course_id IN (?)', course) }

  def published_evaluations
    evaluations.where(published: true)
  end

  def active_model_serializer
    ProjectSerializer
  end

  def evaluation_count_by_user(user)
    Evaluation.joins(:submission).where(:evaluator_id => user, :submissions => {project_id: self}).count
  end

  def average_total_score()
    Evaluation.includes(:project).where(projects: {id: self}).average('total_score')
  end

  def average_total_percentage()
    Evaluation.includes(:project).where(projects: {id: self}).average('total_percentage')
  end

  def statistics_for(user)
    {
      # Count is not accurate for some reason
      project_average_score: average_total_score(),
      project_average_percentage: average_total_percentage(),
      rubric_average_score: rubric.average_total_score(),
      rubric_average_percentage: rubric.average_total_percentage(),
      video_count: submissions.all.count{ |submission| submission.has_video? },
      evaluation_count: evaluation_count_by_user(user)
    }
  end

  def submission_by_user(user)
    submissions.where(:creator_id => user.id).first
  end

  def project_type_human()
    case project_type
      when 'group'
        'groups'
      when 'user'
        'students'
      when 'any'
        'groups and students'
    end
  end

  def evaluatable()
    !rubric.nil?
  end

  def allows_peer_review()
    # TODO: Replace this with a project configuration check
    return true
  end

  def is_group_project?
    project_type =='group' || project_type == 'any'
  end

  def is_user_project?
    project_type =='user' || project_type == 'any'
  end

	def to_s()
		self.name
	end

end
