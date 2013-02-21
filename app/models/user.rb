class User < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :helper_courses, :class_name => "Course", :join_table => "courses_helpers"
  has_and_belongs_to_many :instructor_courses, :class_name => "Course", :join_table => "courses_instructors"
  has_and_belongs_to_many :student_courses, :class_name => "Course", :join_table => "courses_students"

  scope :instructors, where(:role => "instructor")
  scope :students, where(:role => "student")
  scope :admins, where(:role => "admin")

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :name
  # attr_accessible :title, :body

  ROLES = %w(student instructor admin)

  def role?(base_role)
    unless User::ROLES.include? role.to_s
      raise "The role #{role.to_s} doesn't exist."
    end
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def courses
    student_courses + helper_courses + instructor_courses
  end
end
