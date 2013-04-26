class Project < ActiveRecord::Base
  belongs_to :course
  belongs_to :project_type
  belongs_to :rubric
  has_many :submissions
  has_many :submitors, :through => :course
  attr_accessible :description, :name, :course, :rubric_id

  delegate :name, :to => :rubric, :prefix => true, :allow_nil => true
  delegate :department, :to => :course, :prefix => true
  delegate :number, :to => :course, :prefix => true
  delegate :name, :to => :course, :prefix => true
  delegate :section, :to => :course, :prefix => true
  delegate :name_long, :to => :course, :prefix => true
  delegate :name_long, :to => :course, :prefix => true
  delegate :id, :to => :course, :prefix => true


  def active_model_serializer
    ProjectSerializer
  end

  def submission_by_user(user)
    submissions.where(:creator_id => user.id).first
  end

  def allows_peer_review()
    # TODO: Replace this with a project configuration check
    return true
  end

	def to_s()
		self.name
	end

end
