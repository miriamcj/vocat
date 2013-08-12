class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)

    ######################################################
    ### Courses
    ######################################################

    can [:read], Course do |course|
      true if course.role(user)
    end

    can [:update], Course do |course|
      course.role(user) == :evaluator || user.role?('administrator') || course.role(user) == :assistant
    end

    can [:evaluate], Course do |course|
      user.role?('administrator') || (can?(:read, course) && (user.role?(:evaluator) && course.evaluators.include?(user) || user.role?(:creator) && course.settings['enable_peer_review']))
    end

    ######################################################
    ### Projects
    ######################################################

    can [:read, :update, :delete, :index, :new, :edit, :show, :create], Project do |project|
      begin project.course.id rescue raise "Can't determine course role on unattached projects. Try `can? @course.projects.build` instead of `can? Project.new`." end
      can?(:update, project.course)
    end

    can [:submit], Project do |project|
      project.course.creators.include?(user)
      true
    end

    ######################################################
    ### Users
    ######################################################


    ######################################################
    ### Submissions
    ######################################################
    can :own, Submission do |submission|
      submission.creator.id == user.id
    end

    can :annotate, Submission do |submission|
      # TODO: Set who can annotate a submission
      true
    end

    can :evaluate, Submission do |submission|
      # CAN if the user can evaluate for the course and the user is not the creator of this submission
      can?(:evaluate, submission.course) && submission.creator_id != user.id ||
      # CAN if the course allows self evaluation and the user is the creator of this submission
      submission.course.settings['enable_self_evaluation'] && submission.creator_id == user.id
    end

    can :discuss, Submission do |submission|
      if can?(:evaluate, submission) || can?(:own, submission)
        next true
      end
      if submission.course.settings['enable_public_discussions']
        next true
      end
      false
    end

    can :attach, Submission do |submission|
      next true

      if can?(:own, submission) || can?(:evaluate, submission)
        if cannot?(:evaluate, submission)
          if submission.course.settings['enable_creator_attach']
            next true
          else
            next false
          end
        else
          next false
        end
      else
        next false
      end
    end

    can [:read, :update], Submission do |submission|
      if can?(:own, submission)
        next true
      end
      if can?(:evaluate, submission.course)
        next true
      end
    end

    ######################################################
    # Posts
    ######################################################
    can :reply, DiscussionPost do |discussionPost|
      true
    end

    can :manage, DiscussionPost do |discussionPost|
      true
    end



    ######################################################
    # Annotations
    ######################################################
    can :create, Annotation do |annotation|
      if can?(:annotate, annotation.attachment.fileable)
        next true
      end
      false
    end

    can :read, Annotation do |annotation|
      if can?(:read, annotation.attachment.fileable)
        next true
      end
      false
    end

    can :destroy, Annotation do |annotation|
      if user == annotation.author
        next true
      end
      false
    end

    ######################################################
    # Attachments
    ######################################################
    can :create, Attachment do |attachment|
      #TODO: Flesh this out
      true
    end

    can :read, Attachment do |attachment|
      true
    end

    can :update, Attachment do |attachment|
      #TODO: Flesh this out
      true
    end

    can :destroy, Attachment do |attachment|
      #TODO: Flesh this out
      true
    end


    ######################################################
    # Rubrics
    ######################################################
    can :manage, Rubric do |rubric|
      true
    end

    ######################################################
    # Admins can do anything they want.
    ######################################################
    if user.role? :admin
      can :manage, :all
    end

    ######################################################
    # Evaluations
    ######################################################
    can :manage, Evaluation do |evaluation|
      true
    end


  end

end



  #
  #
  #
  #
  #  if user.role? :creator
  #
  #
		#	can :evaluate, Course do |course|
		#		false
		#	end
  #
  #    can :manage, Submission do |submission|
  #      true
  #    end
  #
  #    can :read, Rubric do |rubric|
  #      rubric.owner_id == user.id || rubric.public == true
  #    end
  #
  #
  #    # Creators can evaluate a project if the course and the project allow peer review
  #    can :evaluate, Project do |project|
  #      can? :evaluate, project.course and project.allows_peer_review
  #    end
  #
  #    # Creators can evaluate an exhibit if the user is not the exhibit owner and the project allows evaluation
  #    can :evaluate, Exhibit do |exhibit|
  #      user.id != exhibit.creator.id and can? :evalute, project
  #    end
  #
  #    # Set creator privileges as normal
		#	can :create,      [Attachment]
  #    cannot :destroy,  [Submission, Attachment]
  #  end
  #
  #
  #  if user.role? :evaluator
  #
  #    # Check that the user isn't acting as a
  #    # creator for the current course
  #    can :manage, Course do |course|
  #      not course.creators.include? user
  #    end
  #
  #    can :read, Rubric do |rubric|
  #      rubric.owner_id == user.id || rubric.public == true
  #    end
  #
  #    can :update, Rubric do |rubric|
  #      rubric.owner_id == user.id
  #    end
  #
  #    can :destroy, Rubric do |rubric|
  #      rubric.owner_id == user.id
  #    end
  #
  #    can :manage, Project do |project|
  #      begin
  #        project.course.id
  #      rescue
  #        raise "Can't determine course role on unattached projects. Try `can? @course.projects.build` instead of `can? Project.new`."
  #      end
  #      not project.course.creators.include? user
  #    end
  #
  #    # Revoke creator-only privileges
  #    can :evaluate,    [Submission, Exhibit, Course]
  #    can :create,      [Rubric]
  #    can :create,      [Submission, Attachment]
  #    cannot :destroy,  [Submission, Attachment]
  #    cannot :update,   [Submission, Attachment]
  #
  #  end
  #
  #
  #  # Admins can do whatever
  #  if user.role? :admin
  #    can :manage,      :all
  #  end
  #end


