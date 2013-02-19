class CourseRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  attr_accessible :role

  ROLES = %w(student helper instructor admin)

  def self.set_role(user, course, role)
    unless CourseRole::ROLES.include? role.to_s
      raise "The role #{role.to_s} doesn't exist."
    end
    cr = CourseRole.where(:user_id => user.id, :course_id => course.id).first
    cr.update_attribute(:role, role.to_s)
  end

  def self.get_role(user, course)
    cr = CourseRole.where(:user_id => user.id, :course_id => course.id).first
    unless cr
      return nil # User is not enrolled in the course
    end
    cr.role
  end
end
