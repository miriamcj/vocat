class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role? :student

      can :manage, Course do |course|
        CourseRole.get_role(user, course) == "helper"
      end

      can :read, [Organization, Course, Assignment]
      can :update, Assignment
      can :manage, Submission
    end

    if user.role? :instructor
      can :manage, Course do |course|
        CourseRole.get_role(user, course) != "student"
      end
    end

    if user.role? :admin
      can :manage, :all
    end
  end
end
