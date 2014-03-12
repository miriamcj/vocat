class Course < ActiveRecord::Base
  belongs_to :organization
  belongs_to :semester

  has_and_belongs_to_many :evaluators, :class_name => "User", :join_table => "courses_evaluators"
  has_and_belongs_to_many :assistants, :class_name => "User", :join_table => "courses_assistants"
  has_and_belongs_to_many :creators, :class_name => "User", :join_table => "courses_creators"

  has_many :projects, :dependent => :destroy
  has_many :groups, :dependent => :destroy
  has_one :project_type
  has_many :submissions, :through => :projects, :dependent => :destroy
  delegate :name, :to => :semester, :prefix => true, :allow_nil => true

  accepts_nested_attributes_for :groups

  ALLOWED_SETTINGS = [:enable_creator_attach, :enable_self_evaluation, :enable_peer_review, :enable_public_discussion]
  store_accessor :settings, *ALLOWED_SETTINGS

  scope :sorted, -> { includes(:semester).order ('year DESC, semesters.position DESC') }

  after_initialize :ensure_settings

  validates :department, :name, :number, :section, :presence => true
  #validates :evaluators, :length => {:minimum => 1, :message => "can't be empty."}
  #validates :creators, :length => {:minimum => 1, :message => "can't be empty."}

  # Params is a hash of search values including (:department || :semester || :year) || :section
  def self.search(params)
    c = Course.all
    c = c.where({department: params[:department]}) unless params[:department].blank?
    c = c.where({year: params[:year]}) unless params[:year].blank?
    c = c.where({section: params[:section]}) unless params[:section].blank?
    c = c.joins(:semester).where(:semesters => {id: params[:semester]}) unless params[:semester].blank?
    c
  end

  def members
    creators + evaluators + assistants
  end

  def self.distinct_departments
    Course.uniq.pluck(:department).sort
  end

  def self.distinct_years
    years = Course.uniq.pluck(:year)
    years.reject! { |y| y.nil? }
    years.sort
  end

  def allows_public_discussion?
    get_boolean_setting_value('enable_public_discussion')
  end

  def allows_peer_review?
    get_boolean_setting_value('enable_peer_review')
  end

  def allows_self_evaluation?
    get_boolean_setting_value('enable_self_evaluation')
  end

  def allows_creator_attach?
    get_boolean_setting_value('enable_creator_attach')
  end

  def ensure_settings()
    self.settings = {} unless self.settings.kind_of? Hash
    self.settings = self.settings.with_indifferent_access
  end

  def list_name
    "[#{section}] #{department}#{number}: #{name}, #{semester_name} #{year}"
  end

  def to_s
    "#{department}#{number}: #{name}, Section #{section}"
  end

  def disenroll(user)
    if role(user).nil? then
      errors.add :base, 'Unable to disenroll user from course because user does not currently belong to course.'
      return false
    else
      if creators.include?(user) then creators.delete(user) end
      if evaluators.include?(user) then evaluators.delete(user) end
      if assistants.include?(user) then assistants.delete(user) end
      return true
    end
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
    out = out.gsub("%y", year.to_s)
    unless semester.nil?
      out = out.gsub("%S", semester.name)
    end
    out
  end

  def submission_video_percentage()
    out = 0
    video_count = Video.count_by_course(self)
    if video_count > 0
      possible_submissions = creators.count * projects.count + groups.count * projects.count
      if possible_submissions.to_f > 0
        out = ((video_count.to_f / possible_submissions.to_f) * 100).round
      end
    end
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

  def name_long
    self.to_s
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
