class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)

    if user.role? :creator

			can :show_exhibits_for, User, :id => user.id

      # Creators acting as assistants can manage course information
      can :update, Course do |course|
        course.assistants.include? user
      end

      # Creators acting as assistants can manage projects
      can :manage, Project do |project|
        begin
          project.course.id
        rescue
          raise "Can't determine course role on unattached projects. Try `can? @course.projects.build` instead of `can? Project.new`."
        end
        project.course.assistants.include? user
      end

      can :own, Submission do |submission|
        submission.creator.id == user.id
      end

      # Creators can update submissions that they own
      can :update, Submission do |submission|
        can? :own, submission
      end

			can :evaluate, Course do |course|
				false
			end

      # Creators can evaluate a project if the course and the project allow peer review
      can :evaluate, Project do |project|
        can? :evaluate, project.course and project.allows_peer_review
      end

      # Creators can evaluate an exhibit if the user is not the exhibit owner and the project allows evaluation
      can :evaluate, Exhibit do |exhibit|
        user.id != exhibit.creator.id and can? :evalute, project
      end

      # Set creator privileges as normal
      cannot :destroy,  [Submission, Attachment]
    end


    if user.role? :evaluator

      # Check that the user isn't acting as a
      # creator for the current course
      can :manage, Course do |course|
        not course.creators.include? user
      end

      can :read, Rubric do |rubric|
        rubric.owner_id == user.id
      end

      can :update, Rubric do |rubric|
        rubric.owner_id == user.id
      end

      can :destroy, Rubric do |rubric|
        rubric.owner_id == user.id
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
      can :evaluate,    [Submission, Exhibit, Course]
      can :create,      [Rubric]
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
