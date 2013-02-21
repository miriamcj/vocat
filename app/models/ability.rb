class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)

    if user.role? :student
      # Students acting as helpers can
      # update course information and assignments
      can :update, Course do |course|
        role = CourseRole.get_role(user, course)
        role && role == "helper"
      end
      can :manage, Assignment do |assignment|
        begin
          assignment.course.id
        rescue
          raise "Can't determine course role on unattached assignments. Try `can? @course.assignments.build` instead of `can? Assignment.new`."
        end
        role = CourseRole.get_role(user, assignment.course)
        role && role == "helper"
      end

      # Set student privileges as normal
      can :read,        [Organization, Course, Assignment]
      can :manage,      [Submission, Attachment]
      cannot :destroy,  [Submission, Attachment]
    end


    if user.role? :instructor
      # Check that the user isn't acting as a
      # student for the current course
      can :manage, Course do |course|
        role = CourseRole.get_role(user, course)
        role && role != "student"
      end
      can :manage, Assignment do |assignment|
        begin
          assignment.course.id
        rescue
          raise "Can't determine course role on unattached assignments. Try `can? @course.assignments.build` instead of `can? Assignment.new`."
        end
        role = CourseRole.get_role(user, assignment.course)
        role && role != "student"
      end

      # Revoke student-only privileges
      cannot :create,   [Submission, Attachment]
      cannot :destroy,  [Submission, Attachment]
      cannot :update,   [Submission, Attachment]
    end


    # Admins can do whatever
    if user.role? :admin
      can :manage,      :all
    end
  end
end
