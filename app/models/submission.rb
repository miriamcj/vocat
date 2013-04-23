class Submission < ActiveRecord::Base
  has_many :attachments, :as => :fileable
  has_many :evaluations
  belongs_to :project
	has_one :course, :through => :project
  belongs_to :creator, :class_name => "User"
  attr_accessible :name, :evaluations, :summary, :attachments, :project, :course, :url, :thumb

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

  def active_model_serializer
	  SubmissionSerializer
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
