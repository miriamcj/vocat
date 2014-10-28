class User < ActiveRecord::Base

  belongs_to :organization
  has_many :rubrics, :foreign_key => :owner_id
  has_and_belongs_to_many :assistant_courses, :class_name => "::Course", :join_table => "courses_assistants"
  has_and_belongs_to_many :evaluator_courses, :class_name => "::Course", :join_table => "courses_evaluators"
  has_and_belongs_to_many :creator_courses, :class_name => "::Course", :join_table => "courses_creators"
  has_and_belongs_to_many :groups, :join_table => "groups_creators"

  has_many :submissions, :as => :creator, :dependent => :destroy

  has_many :course_requests

  default_scope { order("last_name ASC") }
  scope :evaluators, -> { where(:role => "evaluator") }
  scope :creators, -> { where(:role => "creator") }
  scope :administrators, -> { where(:role => "administrator") }

  serialize :settings, Hash

  delegate :can?, :cannot?, :to => :ability
  delegate :name, :to => :organization, :prefix => true, :allow_nil => true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  ROLES = %w(creator evaluator administrator)

  DEFAULT_SETTINGS = {
    'enable_glossary' => {value: false, type: 'boolean' }
  }

  validates :first_name, :last_name, :role, :presence => true

  # Params is a hash of search values including (:department || :semester || :year) || :section
  def self.search(params)
    u = User.all
    if params[:last_name] then u = u.where(["lower(last_name) LIKE :last_name", {:last_name => "#{params[:last_name].downcase}%"}]) end
    if params[:email] then u = u.where(["lower(email) LIKE :email", {:email => "#{params[:email].downcase}%"}]) end
    if params[:role] then u = u.where({role: params[:role]}) unless params[:role].blank? end
    u
  end

  def role?(base_role)
    unless User::ROLES.include? role.to_s
      raise "The role #{role.to_s} doesn't exist."
    end
    base_role.to_s == role.to_s
  end

  def to_s
    name
  end

  def name
    "#{first_name} #{last_name}"
  end

  def list_name
    [last_name, first_name].reject{ |s| s.blank? }.join(', ')
  end

  def course_groups(course)
    groups.where(:course => course)
  end

  def is_group?
    false
  end

  def is_user?
    true
  end

  def creator_type
    "User"
  end

  def has_courses
    if self.courses.count() > 0
      true
    else
      false
    end
  end

  def available_rubrics
    Rubric.public_or_owned_by(self)
  end

  def courses
    creator_courses + assistant_courses + evaluator_courses
  end

  def ability
    @ability ||= Ability.new(self)
  end


  def update_settings(settings)
    keys_intersection = settings.keys & User::DEFAULT_SETTINGS.keys
    keys_intersection.each do |key|
      self.settings[key] = settings[key]
    end
  end

  def get_setting_value(key)
    default = User::DEFAULT_SETTINGS[key]
    if self.settings.has_key? key
      out = self.settings[key]
      if !default.nil? && default[:type]
        case default[:type]
          when 'boolean'
            out = out == '1' || out == 1 || out.downcase == 'true' || out == true ? true : false
        end
      end
    else
      if default.nil?
        out = nil
      else
        out = default[:value]
      end
    end
    out
  end

  # TODO: Refactor this; Adding itself to the course is not the job of the user.
  def enroll(course, enrollment_role = nil)
    if creator_courses.include?(course) || evaluator_courses.include?(course) || assistant_courses.include?(course)
      errors.add :base, "#{list_name} is already associated with this course."
      return false
    end
    if enrollment_role.nil?
      enrollment_role = role
    end
    #if role?(:creator) && enrollment_role.to_s == 'evaluator'
    #  enrollment_role = 'creator'
    #end
    if enrollment_role.eql?('creator') then course.creators << self end
    if enrollment_role.eql?('evaluator') then course.evaluators << self end
    if enrollment_role.eql?('administrator') then course.evaluators << self end
    if enrollment_role.eql?('assistant') then course.assistants << self end
  end

  def to_csv_header_row
    %w(VocatId FullName LastName FirstName Email OrgIdentity)
  end

  def to_csv
    [id, list_name, last_name, first_name, email, org_identity]
  end

end
