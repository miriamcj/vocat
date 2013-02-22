class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)

    if user.role? :creator
      # Creators acting as assistants can
      # update course information and projects
      can :update, Course do |course|
        course.assistants.include? user
      end
      can :manage, Project do |project|
        begin
          project.course.id
        rescue
          raise "Can't determine course role on unattached projects. Try `can? @course.projects.build` instead of `can? Project.new`."
        end
        project.course.assistants.include? user
      end

      # Set creator privileges as normal
      can :read,        [Organization, Course, Project]
      can :manage,      [Submission, Attachment]
      cannot :destroy,  [Submission, Attachment]
    end


    if user.role? :evaluator
      # Check that the user isn't acting as a
      # creator for the current course
      can :manage, Course do |course|
        not course.creators.include? user
      end
      can :manage, Project do |project|
        begin
          project.course.id
        rescue
          raise "Can't determine course role on unattached projects. Try `can? @course.projects.build` instead of `can? Project.new`."
        end
        not project.course.creators.include? user
      end

      # Revoke creator-only privileges
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
