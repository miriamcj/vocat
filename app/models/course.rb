class Course < ActiveRecord::Base
  belongs_to :organization
  has_many :course_roles
  has_many :users, :through => :course_roles
  has_many :assignments
  has_one :assignment_type

  attr_accessible :department, :description, :name, :number, :section

  default_scope order("department ASC, number ASC, section ASC")

  def instructors
    course_roles.where(:role => "instructor")
  end

  def helpers
    course_roles.where(:role => "helper")
  end

  def students
    course_roles.where(:role => "student")
  end

end
