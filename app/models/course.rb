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

  def add_instructors(users)
    users.each {|user| add_user(user, :instructor)}
  end

  def add_instructor(user)
    add_user(user, :instructor)
  end

  def add_helpers(users)
    users.each {|user| add_user(user, :helper)}
  end

  def add_helper(user)
    add_user(user, :helper)
  end

  def add_students(users)
    users.each {|user| add_user(user, :student)}
  end

  def add_student(user)
    add_user(user, :student)
  end

  def to_s
    "#{department}#{number} #{name} - #{section}"
  end

  protected

  def add_user(user, role)
    users << user
    CourseRole.set_role(user, self, role)
  end

end
