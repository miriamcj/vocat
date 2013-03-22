class User < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :assistant_courses, :class_name => "Course", :join_table => "courses_assistants"
  has_and_belongs_to_many :evaluator_courses, :class_name => "Course", :join_table => "courses_evaluators"
  has_and_belongs_to_many :creator_courses, :class_name => "Course", :join_table => "courses_creators"

  scope :evaluators, where(:role => "evaluator")
  scope :creators, where(:role => "creator")
  scope :admins, where(:role => "admin")

  delegate :can?, :cannot?, :to => :ability

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  default_scope order("name ASC")

  ROLES = %w(creator evaluator admin)

  def role?(base_role)
    unless User::ROLES.include? role.to_s
      raise "The role #{role.to_s} doesn't exist."
    end
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def has_courses
    if self.courses.count() > 0
      true
    else
      false
    end
  end

  def courses
    creator_courses + assistant_courses + evaluator_courses
  end

  def ability
    @ability ||= Ability.new(self)
  end



end
