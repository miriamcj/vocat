class Submission < ActiveRecord::Base
  has_many :attachments, :as => :fileable
  has_many :evaluations
  belongs_to :project
	has_one :course, :through => :project
  belongs_to :creator, :class_name => "User"
  attr_accessible :name, :evaluations, :summary, :project_id, :url, :published,
                  :thumb, :instructor_score_percentage, :creator_id, :attachment_ids

  delegate :department, :to => :course, :prefix => true
  delegate :number, :to => :course, :prefix => true
  delegate :name, :to => :course, :prefix => true
  delegate :section, :to => :course, :prefix => true
  delegate :name_long, :to => :course, :prefix => true
  delegate :id, :to => :course, :prefix => true
  delegate :name, :to => :project, :prefix => true
  delegate :name, :to => :creator, :prefix => true

  scope :for_course, lambda { |course| joins(:project).where('projects.course_id' => course).includes(:attachments) }
  scope :for_creator, lambda { |creator| where('creator_id' => creator).includes(:course, :project, :attachments) }
  scope :for_creator_and_course, lambda { |creator, course| where('creator_id' => creator, 'projects.course_id' => course).includes(:course, :project, :attachments) }
  scope :for_creator_and_project, lambda { |creator, project| where('creator_id' => creator, 'project_id' => project).includes(:course, :project, :attachments) }

  def active_model_serializer
	  SubmissionSerializer
  end

  def instructor_evaluations
    self.evaluations.published.created_by(self.course.evaluators)
  end

  def peer_evaluations
		self.evaluations.published.created_by(self.course.creators)
  end

  def peer_score_total
	  score_total('peer')
  end

  def instructor_score_total
	  score_total('instructor')
  end

  def instructor_score_count
    self.instructor_evaluations.count
  end

  def peer_score_count
	  self.peer_evaluations.count
  end

  def instructor_score_percentage
		score_percentage('instructor')
  end

  def video_attachment_id
    if self.attachments.count() > 0
      self.attachments.first().id
    else
      nil
    end
  end

  def attachment
    self.attachments.first()
  end

  def transcoding_error?
    self.attachment && self.attachment.transcoding_error != nil ? true : false
  end

  def transcoded_attachment
    self.attachments.where(:transcoding_status => 1).first
  end

  def transcoded_attachment?
    self.transcoded_attachment != nil ? true : false
  end

  def uploaded_attachment?
    self.attachments.count() > 0 ? true: false
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

	private

  def score_total(type)
	  if type == 'instructor'
		  evaluations = self.instructor_evaluations
	  elsif type == 'peer'
		  evaluations = self.peer_evaluations
	  else
		  raise ArgumentError, "score_total expects type to be 'instructor' or 'peer'"
	  end

	  sum = 0.0
	  evaluations.each do |evaluation|
		  sum = sum + evaluation.total_percentage
	  end
	  sum
  end

  def scored_by_instructor?()
    instructor_score_count > 0
  end

  def score_percentage(type)
	  if type == 'instructor'
		  total_score = instructor_score_total
		  total_count = instructor_score_count
	  elsif type == 'peer'
		  total_score = peer_score_total
		  total_count = peer_score_count
	  else
		  raise ArgumentError, "score_percentage expects type to be 'instructor' or 'peer'"
	  end
	  if total_score >= 0 && total_count > 0
		  (total_score.to_f / total_count).to_i()
	  else
		  0
	  end
  end


end
