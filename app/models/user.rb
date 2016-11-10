# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  role                   :string
#  organization_id        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  middle_name            :string
#  settings               :text
#  org_identity           :string
#  gender                 :string
#  city                   :string
#  state                  :string
#  country                :string
#  is_ldap_user           :boolean
#  preferences            :hstore           default({}), not null
#
# Indexes
#
#  index_users_on_email_and_organization_id  (email,organization_id) UNIQUE
#  index_users_on_organization_id            (organization_id)
#  index_users_on_reset_password_token       (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base

  belongs_to :organization
  has_many :rubrics, :foreign_key => :owner_id
  has_many :memberships
  has_many :courses, :through => :memberships

  has_many :creator_courses, -> { where '"memberships"."role" = ?', 'creator' }, :through => :memberships, :source => "course"
  has_many :evaluator_courses, -> { where '"memberships"."role" = ?', 'evaluator' }, :through => :memberships, :source => "course"
  has_many :assistant_courses, -> { where '"memberships"."role" = ?', 'assistant' }, :through => :memberships, :source => "course"

  has_and_belongs_to_many :groups, :join_table => "groups_creators"
  has_many :submissions, :as => :creator, :dependent => :destroy
  has_many :course_requests
  has_many :course_events, as: :loggable
  has_many :visits

  default_scope { order("last_name ASC") }
  scope :evaluators, -> { where(:role => "evaluator") }
  scope :creators, -> { where(:role => "creator") }
  scope :administrators, -> { where(:role => "administrator") }
  scope :superadministrators, -> { where(:role => "superadministrator") }
  scope :in_org, ->(org) { where(:organization => org)}

  serialize :settings, Hash

  delegate :can?, :cannot?, :to => :ability
  delegate :name, :to => :organization, :prefix => true, :allow_nil => true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, request_keys: { subdomain: false }

  ROLES = %w(creator evaluator administrator superadministrator)
  ORG_ROLES = %w(creator evaluator administrator)

  DEFAULT_SETTINGS = {
      'enable_glossary' => {value: false, type: 'boolean'}
  }

  validates :first_name, :last_name, :role, :presence => true
  validates_presence_of   :email
  validates_uniqueness_of :email, allow_blank: true, if: :email_changed?, :scope => :organization_id
  validates_format_of     :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/, allow_blank: true, if: :email_changed?
  validates_presence_of     :password, if: Proc.new{|obj| obj.new_record? }
  validates_confirmation_of :password, if: Proc.new{|obj| obj.new_record? }
  validates_length_of       :password, within: (7..72), allow_blank: true
  validates_exclusion_of :role, :in => %w[superadministrator], message: 'cannot be "superadministrator" if the user belongs to an organization', if: :in_org?
  validates_presence_of :organization_id, unless: :is_superadministrator?

  def self.find_for_authentication(warden_conditions)
    joins('LEFT JOIN organizations ON users.organization_id = organizations.id').where(
        'users.email = ? AND (organizations.subdomain = ? OR users.role = ?)',
        warden_conditions[:email],
        warden_conditions[:subdomain].split('.').first.downcase,
        'superadministrator'
    ).first
  end

  # Params is a hash of search values including (:department || :semester || :year) || :section
  def self.search(params)
    u = User.all
    if params[:last_name] then
      u = u.where(["lower(last_name) LIKE :last_name", {:last_name => "#{params[:last_name].downcase}%"}])
    end
    if params[:email] then
      u = u.where(["lower(email) LIKE :email", {:email => "#{params[:email].downcase}%"}])
    end
    if params[:role] then
      u = u.where({role: params[:role]}) unless params[:role].blank?
    end
    u
  end

  def role?(base_role)
    unless User::ROLES.include? role.to_s
      Rails.logger.info  "The role #{role.to_s} doesn't exist. User.role? was passed a base role of '#{base_role}' for user '#{self.id}' with email '#{self.email}"
      return false
    end
    base_role.to_s == role.to_s
  end

  def sorted_grouped_upcoming_courses
    self.courses.current_and_upcoming.order('year ASC').group_by do |course|
      "#{course.semester} #{course.year}"
    end
  end

  def to_s
    name
  end

  def name
    "#{first_name} #{last_name}"
  end

  def list_name
    [last_name, first_name].reject { |s| s.blank? }.join(', ')
  end

  def course_groups(course)
    groups.where(:course => course)
  end

  def in_org?
    !self.organization_id.nil?
  end

  def is_group?
    false
  end

  def is_superadministrator?
    role == 'superadministrator'
  end

  def is_user?
    true
  end

  def creator_type
    "User"
  end

  def sorted_courses(limit = nil)
    courses.sorted.limit(limit)
  end

  def grouped_sorted_courses(limit = nil)
    sorted_courses(limit).group_by do |course|
      "#{course.semester} #{course.year}"
    end
  end

  def has_courses
    if self.courses.count() > 0
      true
    else
      false
    end
  end

  def has_unreviewed_work?(course_id)
    last_visit = self.visits.where(visitable_course_id: course_id).most_recent
    last_course_event = CourseEvent.non_destructive.where(course_id: course_id).last
    return false if last_course_event.nil?
    return true if last_visit.blank? && last_course_event
    return true if last_visit.updated_at <= last_course_event.created_at
    return false
  end

  def available_rubrics
    Rubric.public_or_owned_by(self)
  end

  def courses_count
    courses.count
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

  def update_preference(key, value)
    preferences = self.preferences.clone || {}
    preferences[key] = value
    self.preferences = preferences
    self.save
  end

  def get_preference(key)
    preferences = self.preferences || {}
    if preferences.has_key? key
      preferences[key]
    else
      nil
    end
  end

  def set_default_creator_type_for_course(course, type)
    key = "course_#{course.id}_creator_type_default"
    update_preference(key, type)
  end

  def get_default_creator_type_for_course(course)
    key = "course_#{course.id}_creator_type_default"
    get_preference(key)
  end

  def to_csv_header_row
    %w(VocatId FullName LastName FirstName Email OrgIdentity)
  end

  def to_csv
    [id, list_name, last_name, first_name, email, org_identity]
  end

end
