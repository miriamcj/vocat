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

    can [:read_only], User do |a_user|
      user.role?(:evaluator) || user.role?(:administrator)
    end

    can [:search], User do |a_user|
      user.role?(:evaluator)
    end

    ######################################################
    ### Courses
    ######################################################

    can [:read_only], Course do |course|
      res = course.role(user)
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
      course.role(user) == :evaluator || course.role(user) == :assistant
    end

    can [:show_submissions], Course do |course|
      if course.role(user) == :evaluator || course.role(user) == :assistant
        has_ability = true
      elsif course.role(user) == :creator && course.has_at_least_one_creator_visible_project?
        has_ability = true
      else
        has_ability = false
      end
      has_ability
    end

    ######################################################
    ### Projects
    ######################################################

    can [:read_only], Project do |project|
      can?(:read_only, project.course)
    end

    can [:evaluate], Project do |project|
      course = project.course
      course.role(user) == :evaluator ||
          course.role(user) == :assistant ||
          course.role(user) == :creator && project.allows_peer_review?
    end

    can [:show_submissions], Project do |project|
      course = project.course
      course.role(user) == :evaluator ||
          course.role(user) == :assistant ||
          (course.role(user) == :creator && (project.allows_public_discussion? || project.allows_peer_review?))
    end

    can [:read_write_destroy], Project do |project|
      can?(:read_write, project.course)
    end

    can [:position], Project do |project|
      can?(:update, project)
    end

    can [:submit], Project do |project|
      project.course.role(user) == :creator
    end

    can [:export], Project do |project|
      can?(:administer, project.course)
    end

    can [:publish_evaluations], Project do |project|
      can?(:evaluate, project)
    end

    can [:unpublish_evaluations], Project do |project|
      can?(:publish_evaluations, project)
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
      submission.project.course.role(user) && (submission.project.allows_peer_review? || submission.project.allows_public_discussion?)
    end

    can :annotate, Submission do |submission|
      can?(:evaluate, submission) || can?(:own, submission) || can?(:read_only, submission)
    end

    can :administer, Submission do |submission|
      (user.role?(:administrator))
    end

    can :do_reassign, Submission do |submission|
      can(:administer, submission)
    end

    can :reassign, Submission do |submission|
      can(:administer, submission)
    end

    can :destroy, Submission do |submission|
      can(:administer, submission)
    end

    can :destroy_confirm, Submission do |submission|
      can(:destroy, submission)
    end

    can :evaluate, Submission do |submission|
      # User can evaluate if:
      # 1) user can evaluate for the course and is not the creator of the submission
      # 2) submission is a user submission and self evaluation is allowed and evaluator is the creator
      # 3) submission is a group submission and self evaluation is allowed and evaluator is in the group.
      # 4) submission project allows peer review and the user is not the creator of the submission
      results = submission.has_rubric? && can?(:evaluate, submission.project.course) && submission.creator != user ||
          submission.creator.is_user? && submission.project.allows_self_evaluation? && submission.creator == user ||
          submission.creator.is_group? && submission.project.allows_self_evaluation? && submission.creator.include?(user) ||
          submission.creator != user && submission.project.allows_peer_review?
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
          (
          can?(:own, submission) &&
              submission.project.allows_creator_attach? &&
              !(submission.project.rejects_past_due_media? && submission.project.due_date && submission.project.due_date.past?)

          )
    end

    can :discuss, Submission do |submission|
      (submission.project.course.role(user) == :evaluator && can?(:evaluate, submission)) ||
          can?(:own, submission) ||
          (submission.project.allows_public_discussion? && submission.project.course.role(user))
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
      can?(:annotate, annotation.asset.submission)
    end

    can :create, Annotation do |annotation|
      can?(:annotate, annotation.asset.submission)
    end

    can :read_write_destroy, Annotation do |annotation|
      annotation.author == user || annotation.asset.submission.project.course.role(user) == :evaluator
    end

    ######################################################
    # Assets
    ######################################################

    can :read_only, Asset do |asset|
      can?(:show, asset.submission)
    end

    can :read_write_destroy, Asset do |asset|
      can?(:attach, asset.submission)
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

    if user.role?(:evaluator) || user.role?(:administrator)
      can :create, Rubric
    else
      cannot :create, Rubric
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
      cannot [:evaluate], Submission do |submission|
        result = submission.project.course.role(user) != :evaluator
        result
      end
      cannot [:portfolio], Course do |course|
        result = course.role(user) != :creator
        result
      end
    end

  end
end


