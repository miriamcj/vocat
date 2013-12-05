class User < ActiveRecord::Base

  belongs_to :organization
  has_many :rubrics, :foreign_key => :owner_id
  has_and_belongs_to_many :assistant_courses, :class_name => "::Course", :join_table => "courses_assistants"
  has_and_belongs_to_many :evaluator_courses, :class_name => "::Course", :join_table => "courses_evaluators"
  has_and_belongs_to_many :creator_courses, :class_name => "::Course", :join_table => "courses_creators"
  has_and_belongs_to_many :groups, :join_table => "groups_creators"

  has_many :submissions, :as => :creator

  default_scope { order("last_name ASC") }
  scope :evaluators, -> { where(:role => "evaluator") }
  scope :creators, -> { where(:role => "creator") }
  scope :administrators, -> { where(:role => "administrator") }

  serialize :settings, Hash


  delegate :can?, :cannot?, :to => :ability

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  ROLES = %w(creator evaluator administrator)

  DEFAULT_SETTINGS = {
    'enable_glossary' => {value: false, type: 'boolean' }
  }

  # Params is a hash of search values including (:department || :semester || :year) || :section
  def self.search(params)
    u = User.all
    u = u.where({last_name: params[:last_name]}) unless params[:last_name].blank?
    u = u.where({email: params[:email]}) unless params[:email].blank?
    u = u.where({role: params[:role]}) unless params[:role].blank?
    u
  end

  def role?(base_role)
    unless User::ROLES.include? role.to_s
      raise "The role #{role.to_s} doesn't exist."
    end
    base_role.to_s == role.to_s
  end

  def name
    "#{first_name} #{last_name}"
  end

  def list_name
    [last_name, first_name].reject{ |s| s.blank? }.join(', ')
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

  def to_csv_header_row
    %w(VocatId FullName LastName FirstName Email OrgIdentity)
  end

  def to_csv
    [id, list_name, last_name, first_name, email, org_identity]
  end


end
