class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :show, :to => :show_only
    alias_action :index, :show, :to => :read_only
    alias_action :index, :show, :edit, :new, :create, :update, :to => :read_write
    alias_action :index, :show, :edit, :new, :create, :update, :destroy, :to => :read_write_destroy

    user ||= User.new # guest user (not logged in)


    ######################################################
    ### Users
    ######################################################

    can [:read_write], User do |a_user|
      user == a_user
    end

    can [:search], User do |a_user|
      user.role?(:evaluator)
    end

    ######################################################
    ### Courses
    ######################################################

    can [:read_only], Course do |course|
      res =  course.role(user)
      true if res
    end

    can [:portfolio], Course do |course|
      course.role(user) == :creator
    end

    # Note that we are not currently allowing evaluators to destroy courses.
    can [:read_write], Course do |course|
      course.role(user) == :evaluator || course.role(user) == :assistant
    end

    can [:administer], Course do |course|
      course.role(user) == :evaluator || course.role(user) == :assistant
    end

    can [:evaluate], Course do |course|
      course.role(user) == :evaluator || course.role(user) == :assistant || user.role?(:creator) && course.allows_peer_review?
    end

    can [:show_submissions], Course do |course|
      course.role(user) == :evaluator || course.role(user) == :assistant || can?(:read_only, course) && (can?(:evaluate, course) || course.allows_public_discussion?)
    end

    ######################################################
    ### Projects
    ######################################################

    can [:read_only], Project do |project|
      can?(:read_only, project.course)
    end

    can [:read_write_destroy], Project do |project|
      can?(:read_write, project.course)
    end

    can [:position], Project do |project|
      can?(:update, project)
    end

    can [:submit], Project do |project|
      project.course.creators.include?(user)
    end

    ######################################################
    ### Submissions
    ######################################################

    can :own, Submission do |submission|
      (submission.creator_type == 'User' && submission.creator == user) ||
          (submission.creator_type == 'Group' && can?(:belong_to, submission.creator))
    end

    can :read_write, Submission do |submission|
      can?(:own, submission) || submission.project.course.role(user) == :evaluator || submission.project.course.role(user) == :assistant
    end

    can :read_only, Submission do |submission|
      # Enabling public discussion assumes that submissions are visible to users.
      can?(:evaluate, submission.project.course) || submission.project.course.allows_public_discussion? && can?(:show, submission.project.course)
    end

    can :annotate, Submission do |submission|
      can?(:evaluate, submission) || can?(:own, submission)
    end

    can :evaluate, Submission do |submission|
      # User can evaluate if:
      # 1) user can evaluate for the course and is not the creator of the submission
      # 2) submission is a user submission and self evaluation is allowed and evaluator is the creator
      # 3) submission is a group submission and self evaluation is allowed and evaluator is in the group.
      results = can?(:evaluate, submission.project.course ) && submission.creator != user ||
        submission.creator.is_user? && submission.project.course.allows_self_evaluation? && submission.creator == user ||
        submission.creator.is_group? && submission.project.course.allows_self_evaluation? && submission.creator.include?(user)
      results
    end

    can :attach, Submission do |submission|
      # CAN if the user is an administrator
      (user.role?(:administrator)) ||
      # CAN if the user is not the submission owner, and is an evaluator or assistant for the course
      (
        !can?(:own, submission) &&
        (
          submission.project.course.role(user) == :assistant ||
          submission.project.course.role(user) == :evaluator
        )
      ) ||
      # CAN if the user is the submission owner and enable_creator_attach is true
      (can?(:own, submission) && submission.project.course.allows_creator_attach?)
    end

    can :discuss, Submission do |submission|
      (submission.project.course.role(user) == :evaluator && can?(:evaluate, submission)) || can?(:own, submission) || (submission.project.course.allows_public_discussion? && can?(:show, submission))
    end

    ######################################################
    ### Groups
    ######################################################
    can :read_only, Group do |group|
      group.course.role(user)
    end

    can :read_write_destroy, Group do |group|
      group.course.role(user) == :evaluator || group.course.role(user) == :administrator
    end

    can :belong_to, Group do |group|
      group.creators.include? user
    end

    can [:show_submissions], Group do |group|
      can?(:show_submissions, group.course) || can?(:belong_to, group)
    end


    ######################################################
    # Posts
    ######################################################
    can :read_only, DiscussionPost do |discussionPost|
      can?(:discuss, discussionPost.submission)
    end

    can :read_write, DiscussionPost do |discussionPost|
      course = discussionPost.submission.project.course
      course.role(user) == :evaluator || discussionPost.author == user
    end

    can :destroy, DiscussionPost do |discussionPost|
      course = discussionPost.submission.project.course
      course.role(user) == :evaluator
    end

    can :reply, DiscussionPost do |discussionPost|
      can?(:discuss, discussionPost.submission)
    end

    can :create, DiscussionPost do |discussionPost|
      can?(:discuss, discussionPost.submission)
    end


    ######################################################
    # Annotations
    ######################################################

    can :read_only, Annotation do |annotation|
      can?(:annotate, annotation.video.submission)
    end

    can :create, Annotation do |annotation|
      can?(:annotate, annotation.video.submission)
    end

    can :read_write_destroy, Annotation do |annotation|
      annotation.author == user || annotation.video.submission.project.course.role(user) == :evaluator
    end

    ######################################################
    # Videos
    ######################################################

    can :read_only, Video do |video|
      can?(:show, video.submission)
    end

    can :read_write_destroy, Video do |video|
      can?(:attach, video.submission)
    end

    ######################################################
    # Attachments
    ######################################################

    # TODO: Improve this ability check
    can :create, Attachment do |attachment|
      true
    end

    can :commit, Attachment do |attachment|
      attachment.user == user
    end

    # TODO: Improve this ability check
    can :show, Attachment do |attachment|
      true
    end


    ######################################################
    # Rubrics
    ######################################################

    # For now, assume that all rubrics are public
    can :read_only, Rubric do |rubric|
      true
    end

    can :read_write_destroy, Rubric do |rubric|
      user == rubric.owner
    end

    can :new, Rubric do |rubric|
      user.role?(:evaluator)
    end

    can :create, Rubric do |rubric|
      user.role?(:evaluator)
    end


    ######################################################
    # Admins
    ######################################################
    if user.role?(:administrator)
      can :manage, :all
      cannot :manage, Evaluation
    end

    ######################################################
    # Course Request
    ######################################################

    can :create, CourseRequest do |course_request|
      user.role?(:evaluator) || user.role?(:administrator)
    end

    ######################################################
    # Evaluations
    ######################################################

    can :read_only, Evaluation do |evaluation|
      can?(:own, evaluation.submission) && evaluation.published == true || evaluation.submission.project.course.role(user) == :evaluator
    end

    can :read_write_destroy, Evaluation do |evaluation|
      evaluation.evaluator == user
    end

    can :create, Evaluation do |evaluation|
      results = can?(:evaluate, evaluation.submission)
      results
    end

    can :new, Evaluation do |evaluation|
      can?(:evaluate, evaluation.submission)
    end

    can :own, Evaluation do |evaluation|
      evaluation.evaluator == user
    end


    ######################################################
    # Admins
    ######################################################
    if user.role?(:administrator)
      can :manage, :all
      cannot [:new, :edit, :create, :update, :destroy], Evaluation do |evaluation|
        result = evaluation.submission.project.course.role(user) != :evaluator
        result
      end
    end

  end
end


