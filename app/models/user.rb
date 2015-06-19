# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  role                   :string(255)
#  organization_id        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string(255)
#  last_name              :string(255)
#  middle_name            :string(255)
#  settings               :text
#  org_identity           :string(255)
#  gender                 :string(255)
#  city                   :string(255)
#  state                  :string(255)
#  country                :string(255)
#  is_ldap_user           :boolean
#  preferences            :hstore           default({}), not null
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

  default_scope { order("last_name ASC") }
  scope :evaluators, -> { where(:role => "evaluator") }
  scope :creators, -> { where(:role => "creator") }
  scope :administrators, -> { where(:role => "administrator") }

  serialize :settings, Hash

  delegate :can?, :cannot?, :to => :ability
  delegate :name, :to => :organization, :prefix => true, :allow_nil => true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w(creator evaluator administrator)
  DEFAULT_SETTINGS = {
      'enable_glossary' => {value: false, type: 'boolean'}
  }

  validates :first_name, :last_name, :role, :presence => true

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

  def is_group?
    false
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
