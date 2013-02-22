class Course < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :instructors, :class_name => "User", :join_table => "courses_instructors"
  has_and_belongs_to_many :helpers, :class_name => "User", :join_table => "courses_helpers"
  has_and_belongs_to_many :students, :class_name => "User", :join_table => "courses_students"
  has_many :projects
  has_one :project_type

  attr_accessible :department, :description, :name, :number, :section, :instructors, :helpers, :students

  validates :department, :name, :number, :section, :presence => true
  validates :instructors, :length => {:minimum => 1, :message => "can't be empty."}
  validates :students, :length => {:minimum => 1, :message => "can't be empty."}

  default_scope order("department ASC, number ASC, section ASC")

  def to_s
    "#{department}#{number} - #{name} - #{section}"
  end

  def role(user)
    return "student" if students.include? user
    return "helper" if helpers.include? user
    return "instructor" if instructors.include? user
  end

end
