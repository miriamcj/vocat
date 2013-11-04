class Course < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :evaluators, :class_name => "User", :join_table => "courses_evaluators"
  has_and_belongs_to_many :assistants, :class_name => "User", :join_table => "courses_assistants"
  has_and_belongs_to_many :creators, :class_name => "User", :join_table => "courses_creators"
  has_many :projects, :dependent => :destroy
  has_many :groups, :dependent => :destroy
  has_one :project_type
  has_many :submissions, :through => :projects

  accepts_nested_attributes_for :groups

  ALLOWED_SETTINGS = [:enable_creator_attach, :enable_self_evaluation, :enable_peer_review, :enable_public_discussion]

  store_accessor :settings, *ALLOWED_SETTINGS


  validates :department, :name, :number, :section, :presence => true
  #validates :evaluators, :length => {:minimum => 1, :message => "can't be empty."}
  #validates :creators, :length => {:minimum => 1, :message => "can't be empty."}

  default_scope { order("department ASC, number ASC, section ASC") }

  def allows_peer_review
    get_boolean_setting_value('enable_peer_review')
  end

  def allows_self_evaluation
    get_boolean_setting_value('enable_self_evaluation')
  end

  def name_long
		self.to_s
  end

  def to_s
    "#{department}#{number}: #{name}, Section #{section}"
  end

  # %n = number
  # %c = name
  # %s = section
  # %d = department
  def format(format)
    out = format.gsub("%n", number.to_s)
    out = out.gsub("%c", name)
    out = out.gsub("%s", section)
    out = out.gsub("%d", department)
  end

  def submission_video_percentage()
    video_count = Video.count_by_course(self)
    possible_submissions = creators.count * projects.count
    out = ((video_count.to_f / possible_submissions.to_f) * 100).round
    out
  end

  def average_evaluator_score()
    Evaluation.average_score_by_course_and_type(self, :evaluator)
  end

  def average_peer_score()
    Evaluation.average_score_by_course_and_type(self, :creator)
  end

  def discussion_post_count()
    DiscussionPost.count_by_course(self)
  end

  def annotation_count()
    Annotation.by_course(self).count
  end

  def recent_submissions(limit = 5)
    submissions.order("updated_at DESC").limit(limit)
  end

  def recent_posts(limit = 5)
    DiscussionPost.by_course(self).limit(limit)
  end

  def role(user)
    return :administrator if user.role? :administrator
    return :creator if creators.include? user
    return :assistant if assistants.include? user
    return :evaluator if evaluators.include? user
  end

  private

  def get_boolean_setting_value(key)
    if settings.has_key?(key)
      value = settings[key]
      return true if value == true || value =~ (/^(true|t|yes|y|1)$/i)
      return false if value == false || value.blank? || value =~ (/^(false|f|no|n|0)$/i)
    else
      return false
    end
  end

end
