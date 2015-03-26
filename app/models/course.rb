class Course < ActiveRecord::Base
  belongs_to :organization
  belongs_to :semester

  has_many :memberships
  has_many :users, :through => :memberships

  has_many :creators, -> { where '"memberships"."role" = ?', 'creator' }, :through => :memberships, :source => "user"
  has_many :evaluators, -> { where '"memberships"."role" = ?', 'evaluator' }, :through => :memberships, :source => "user"
  has_many :assistants, -> { where '"memberships"."role" = ?', 'assistant'  }, :through => :memberships, :source => "user"

  has_many :projects, :dependent => :destroy
  has_many :group_projects
  has_many :open_projects
  has_many :user_projects
  has_many :groups, :dependent => :destroy
  has_many :submissions, :through => :projects, :dependent => :destroy


  delegate :name, :to => :semester, :prefix => true, :allow_nil => true

  accepts_nested_attributes_for :groups

  ALLOWED_SETTINGS = [:enable_creator_attach, :enable_self_evaluation, :enable_peer_review, :enable_public_discussion, :anonymous_peer_review]
  store_accessor :settings, *ALLOWED_SETTINGS

  scope :sorted, -> { includes(:semester).order ('year DESC, semesters.position DESC') }

  after_initialize :ensure_settings

  validates :department, :name, :number, :section, :presence => true

  # Params is a hash of search values including (:department || :semester || :year) || :section
  def self.search(params)
    c = Course.all
    c = c.where({department: params[:department]}) unless params[:department].blank?
    c = c.where({year: params[:year]}) unless params[:year].blank?
    c = c.where("lower(section) LIKE ?", "#{params[:section].downcase}%") unless params[:section].blank?
    c = c.joins(:semester).where(:semesters => {id: params[:semester]}) unless params[:semester].blank?
    c = c.joins(:memberships => :user).where(:users => {id: params[:evaluator]}) unless params[:evaluator].blank?
    c.sorted
  end

  def self.distinct_departments
    Course.uniq.pluck(:department).sort
  end

  def self.count_possible_submissions_for(project)
    course = project.course
    count = 0
    count += course.groups.count if project.accepts_group_submissions?
    count += course.creators.count if project.accepts_user_submissions?
    count
  end

  def count_possible_submissions()
    count = 0
    projects.each do |project|
      count += Course.count_possible_submissions_for project
    end
    count
  end

  def members
    users
  end

  def has_projects?
    projects.count > 0
  end

  def submissions_for_creator(creator)
    factory = SubmissionFactory.new
    factory.course_and_creator(self, creator)
  end

  def self.distinct_years
    years = Course.uniq.pluck(:year)
    years.reject! { |y| y.nil? }
    years.sort
  end

  def has_anonymous_peer_review?
    get_boolean_setting_value('anonymous_peer_review')
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
      users.delete(user)
      return true
    end
  end

  def enroll(user, enrollment_role = nil)
    if users.include?(user)
      user.errors.add :base, "#{user.list_name} is already associated with this course."
      return false
    end
    if enrollment_role.nil?
      enrollment_role = user.role
    end
    membership = memberships.build({:user => user, :role => enrollment_role.to_s})
    membership.save
  end

  # TODO: This is a target for refactoring. I don't see why this should
  # belong to course. Move it to a helper or some kind of presenter class.
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

  def video_count()
    Video.count_by_course(self)
  end

  def submission_video_percentage()
    out = 0
    if video_count > 0
      possible_submissions = count_possible_submissions
      if possible_submissions.to_f > 0
        out = ((video_count.to_f / possible_submissions.to_f) * 100).round
      end
    end
    out
  end

  def count_cretors
    creators.count
  end

  def count_groups
    groups.count
  end

  def average_evaluator_score
    Evaluation.average_score_by_course_and_type(self, :evaluator)
  end

  def average_peer_score
    Evaluation.average_score_by_course_and_type(self, :creator)
  end

  def discussion_post_count
    DiscussionPost.count_by_course(self)
  end

  def annotation_count
    Annotation.by_course(self).count
  end

  def recent_submissions(limit = 5)
    submissions.order("updated_at DESC").limit(limit)
  end

  def recent_posts(limit = 5)
    DiscussionPost.by_course(self).limit(limit)
  end

  def role(user)
    membership = memberships.find_by({user: user})
    if membership
      return membership.role.to_sym()
    end
    return :administrator if user.role? :administrator
    return nil
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
