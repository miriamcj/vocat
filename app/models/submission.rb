class Submission < ActiveRecord::Base
  has_many :attachments, :as => :fileable
  has_many :evaluations
  belongs_to :project
	has_one :course, :through => :project
  belongs_to :creator, :class_name => "User"
  attr_accessible :name, :evaluations, :summary, :attachments, :project, :course, :url, :thumb, :instructor_score_percentage

  delegate :department, :to => :course, :prefix => true
  delegate :number, :to => :course, :prefix => true
  delegate :name, :to => :course, :prefix => true
  delegate :section, :to => :course, :prefix => true
  delegate :name_long, :to => :course, :prefix => true
  delegate :name, :to => :project, :prefix => true
  delegate :name, :to => :creator, :prefix => true
  delegate :id, :to => :course, :prefix => true

  scope :for_course, lambda { |course| joins(:project).where('projects.course_id' => course) }
  scope :for_creator, lambda { |creator| where('creator_id' => creator).includes(:course, :project, :attachments) }
  scope :for_creator_and_course, lambda { |creator, course| where('creator_id' => creator, 'projects.course_id' => course).includes(:course, :project, :attachments) }

  def instructor_evaluations
    self.evaluations.published.created_by(self.course.evaluators)
  end

  def active_model_serializer
	  SubmissionSerializer
  end

  def instructor_score_total
    sum = 0.0
    self.instructor_evaluations.each do |evaluation|
      sum = sum + evaluation.total_percentage
    end
    sum
  end

  def instructor_score_count
    self.instructor_evaluations.count
  end

  def instructor_score_percentage
    total_score = instructor_score_total
    total_count = instructor_score_count
    if total_score >= 0 && total_count > 0
      total_score.to_f / total_count
    else
      0
    end
  end

  def transcoded_attachment
    self.attachments.where(:transcoding_status => 1).first
  end

  def transcoded_attachment?
    self.transcoded_attachment != nil ? true : false
  end

  def url
    if self.transcoded_attachment?
      return transcoded_attachment.url
    end
    return false
  end

  def thumb
    if self.transcoded_attachment?
      return transcoded_attachment.url(:thumb)
    end
    return false
  end


end
