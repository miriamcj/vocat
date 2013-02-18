class User < ActiveRecord::Base

  has_many :course_roles
  has_many :courses, :through => :course_roles

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role
  # attr_accessible :title, :body

  ROLES = %w(student helper instructor admin)

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end
end
