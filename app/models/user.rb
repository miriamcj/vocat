class User < ActiveRecord::Base
  belongs_to :organization
  has_many :course_roles
  has_many :courses, :through => :course_roles

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
end
