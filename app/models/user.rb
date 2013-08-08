class User < ActiveRecord::Base
  belongs_to :organization
  has_many :rubrics, :foreign_key => :owner_id
  has_and_belongs_to_many :assistant_courses, :class_name => "Course", :join_table => "courses_assistants"
  has_and_belongs_to_many :evaluator_courses, :class_name => "Course", :join_table => "courses_evaluators"
  has_and_belongs_to_many :creator_courses, :class_name => "Course", :join_table => "courses_creators"
  has_and_belongs_to_many :groups, :join_table => "groups_creators"

  scope :evaluators, where(:role => "evaluator")
  scope :creators, where(:role => "creator")
  scope :administrators, where(:role => "administrator")

  delegate :can?, :cannot?, :to => :ability

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name

  default_scope order("last_name ASC")

  ROLES = %w(creator evaluator administrator)

  def role?(base_role)
    unless User::ROLES.include? role.to_s
      raise "The role #{role.to_s} doesn't exist."
    end
    base_role.to_s == role.to_s
  end

  def name
    "#{first_name} #{last_name}"
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



end
