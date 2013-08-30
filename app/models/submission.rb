class Submission < ActiveRecord::Base
  has_many :attachments, :as => :fileable, :dependent => :destroy
  has_many :evaluations, :dependent => :destroy
  has_many :discussion_posts, :dependent => :destroy
	has_one :course, :through => :project

  belongs_to :project

  belongs_to :creator, :polymorphic => true

  attr_accessible :name, :evaluations, :summary, :project_id, :url, :published, :creator_id, :creator_type, :project,
                  :thumb, :instructor_score_percentage, :creator, :attachment_ids, :discussion_posts_count

  validates_presence_of :project_id, :creator_id, :creator_type

  delegate :department, :to => :course, :prefix => true
  delegate :number, :to => :course, :prefix => true
  delegate :name, :to => :course, :prefix => true
  delegate :section, :to => :course, :prefix => true
  delegate :name_long, :to => :course, :prefix => true
  delegate :allows_peer_review, :to => :course, :prefix => true
  delegate :allows_self_evaluation, :to => :course, :prefix => true
  delegate :id, :to => :course, :prefix => true
  delegate :name, :to => :project, :prefix => true
  delegate :name, :to => :creator, :prefix => true
  delegate :name, :to => :group, :prefix => true, :allow_nil => true

  scope :for_courses, lambda { |course| joins(:project).where('projects.course_id' => course).includes(:attachments) }

  #default_scope :include => :attachments

  def active_model_serializer
	  SubmissionSerializer
  end

  def evaluated_by_instructor?()
    instructor_evaluation_count > 0
  end

  def peer_evaluations
		self.evaluations.published.created_by(self.course.creators)
  end

  def peer_score_total
    evaluations = self.peer_evaluations
    score_total(evaluations)
  end

  def peer_score_percentage
    total_score = peer_score_total
    total_count = peer_evaluation_count
    score_percentage(total_score, total_count)
  end

  def peer_evaluation_count
    self.peer_evaluations.count
  end

  def instructor_evaluations
    self.evaluations.published.created_by(self.course.evaluators)
  end

  def instructor_score_total
    evaluations = self.instructor_evaluations
	  score_total(evaluations)
  end

  def instructor_evaluation_count
    self.instructor_evaluations.count
  end

  def instructor_score_percentage
    total_score = instructor_score_total
    total_count = instructor_evaluation_count
    score_percentage(total_score, total_count)
  end

  def user_evaluation(user)
    self.evaluations.created_by(user).first()
  end

  def user_score_total(user)
    if evaluated_by_user?(user)
      user_evaluation(user).total_score
    end
  end

  def evaluated_by_user?(user)
    user_evaluation_count(user) > 0
  end

  def user_evaluation_published?(user)
    if evaluated_by_user?(user)
      user_evaluation(user).published
    end
  end

  def user_evaluation_count(user)
    self.evaluations.created_by(user).count
  end

  def user_score_percentage(user)
    if evaluated_by_user?(user)
      user_evaluation(user).total_percentage_rounded
    end
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

  def video
    self.attachment
  end

  def video?
    if attachment
      self.attachment.is_video?
    else
      false
    end
  end

  def has_video?
    video?
  end

  def transcoding_error?
    self.attachment && self.attachment.transcoding_error != nil ? true : false
  end

  def transcoding_in_progress?
    attachment && attachment.transcoding_in_progress?
  end

  def transcoding_complete?
    attachment && attachment.transcoding_complete?
  end

  def transcoded_attachment
    self.attachments.where(:transcoding_status => Attachment::TRANSCODING_STATUS_SUCCESS).first
  end

  def transcoded_attachment?
    self.transcoded_attachment != nil ? true : false
  end

  def uploaded_attachment?
    self.attachments.count() > 0 ? true: false
  end

  def url
    if video?
      return video.url
    end
  end

  def thumb
    if attachment
      attachment.url(:thumb)
    end
  end

  def evaluations_visible_to(user)
    role = course.role(user)
    # Admins and evaluators for the course can see everything
    if role == :administrator || role == :evaluator
      return evaluations
    elsif role == :creator
      if user == creator
        # User is the submission owner, so can see own evaluation plus any published evaluations
        return evaluations.where("evaluator_id = ? OR published = true", user.id)
      else
        return evaluations.where("evaluator_id = ?", user.id)
      end
    end
 end


  private

  def score_total(evaluations)
    sum = 0.0
    evaluations.each do |evaluation|
      sum = sum + evaluation.total_percentage
    end
    sum
  end

  def score_percentage(total_score, total_count)
	  if total_score >= 0 && total_count > 0
		  (total_score.to_f / total_count).to_i()
	  else
		  0
	  end
  end


end
