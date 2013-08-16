class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :new, :show, :index, :create, :read, :update, :destroy, :to => :crud
    alias_action :new, :show, :index, :create, :read, :update, :to => :crud_sans_destroy

    user ||= User.new # guest user (not logged in)

    ######################################################
    ### Courses
    ######################################################

    can [:read, :show], Course do |course|
      true if course.role(user)
    end

    can [:crud_sans_destroy], Course do |course|
      course.role(user) == :evaluator || user.role?('administrator') || course.role(user) == :assistant
    end

    can [:crud], Course do |course|
      course.role(user) == :evaluator || user.role?('administrator') || course.role(user) == :assistant
    end

    can [:evaluate], Course do |course|
      user.role?('administrator') || (can?(:read, course) && (user.role?(:evaluator) && course.evaluators.include?(user) || user.role?(:creator) && course.settings['enable_peer_review']))
    end

    ######################################################
    ### Projects
    ######################################################

    can [:crud], Project do |project|
      can?(:update, project.course)
    end

    can [:submit], Project do |project|
      project.course.creators.include?(user)
    end

    ######################################################
    ### Users
    ######################################################


    ######################################################
    ### Submissions
    ######################################################
    can :own, Submission do |submission|
      submission.creator == user
    end

    can :annotate, Submission do |submission|
      can?(:evaluate, submission) || can?(:own, submission)
    end

    can :evaluate, Submission do |submission|
      # CAN if the user can evaluate for the course and the user is not the creator of this submission
      can?(:evaluate, submission.project.course ) && submission.creator != user ||
      # CAN if the course allows self evaluation and the user is the creator of this submission
      submission.project.course .settings['enable_self_evaluation'] && submission.creator == user
    end

    can :attach, Submission do |submission|
	    # CAN if the user is an administrator
	    (user.role?(:administrator)) ||
	    # CAN if the user is not the submission owner, and is an evaluator for the course
			(!can?(:own, submission) && submission.project.course.role(user) == :evaluator) ||
			# CAN if the user is the submission owner and enable_creator_attach is true
			(can?(:own, submission) && submission.project.course.settings['enable_creator_attach'])
    end

    can :read, Submission do |submission|
      can?(:own, submission) || can?(:evaluate, submission.project.course)
    end

    can :update, Submission do |submission|
      can?(:own, submission) || can?(:evaluate, submission.project.course)
    end

    can :discuss, Submission do |submission|
      (submission.project.course.role(user) == :evaluator && can?(:evaluate, submission)) || can?(:own, submission) || (submission.project.course.settings['enable_public_discussion'] && can?(:evaluate, submission))
    end

    ######################################################
    ### Groups
    ######################################################
    can :read, Group do |group|
      group.course.role(user)
    end

    can :crud, Group do |group|
      group.course.role(user) == :evaluator || group.course.role(user) == :administrator
    end

    ######################################################
    # Posts
    ######################################################
    # TODO: Write spec
    can :crud_sans_destroy, DiscussionPost do |discussionPost|
      can?(:discuss, discussionPost.submission)
      true
    end

    # TODO: Write spec
    can :destroy, DiscussionPost do |discussionPost|
      course = discussionPost.submission.project.course
      course.role(user) == :evaluator || discussionPost.author == user
      true
    end

    # TODO: Write spec
    # TODO: Write block
    can :reply, DiscussionPost do |discussionPost|
      true
    end


    ######################################################
    # Annotations
    ######################################################

    # TODO: Write spec
    can :create, Annotation do |annotation|
      can?(:annotate, annotation.attachment.fileable)
    end

    # TODO: Write spec
    can :read, Annotation do |annotation|
      can?(:read, annotation.attachment.fileable)
    end

    # TODO: Write spec
    can :destroy, Annotation do |annotation|
      user == annotation.author
    end

    ######################################################
    # Attachments
    ######################################################
    # TODO: Write spec
    # TODO: Write block
    can :create, Attachment do |attachment|
      true
    end

    # TODO: Write spec
    # TODO: Write block
    can :read, Attachment do |attachment|
      true
    end

    # TODO: Write spec
    # TODO: Write block
    can :update, Attachment do |attachment|
      true
    end

    can :destroy, Attachment do |attachment|
      true
    end


    ######################################################
    # Rubrics
    ######################################################

    # TODO: Write spec
    # TODO: Write block
    can :manage, Rubric do |rubric|
      true
    end

    ######################################################
    # Admins can do anything they want.
    ######################################################

    # TODO: Write spec?
    if user.role? :admin
      can :manage, :all
    end

    ######################################################
    # Evaluations
    ######################################################

    # TODO: Write spec
    # TODO: Write block
    can :manage, Evaluation do |evaluation|
      true
    end


  end

end


