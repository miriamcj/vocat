module Concerns::OrganizationValidator
  extend ActiveSupport::Concern

  protected

  def org_validate_course
    fail_organization_validation if @course.organization != @current_organization unless @course.blank?
  end

  def org_validate_annotation
    fail_organization_validation if @annotation.asset.submission.project.course.organization != @current_organization unless @annotation.blank?
  end

  def org_validate_asset
    fail_organization_validation if @asset.submission.project.course.organization != @current_organization unless @asset.blank?
  end

  def org_validate_attachment
    fail_organization_validation if @attachment.submission.project.course.organization != @current_organization unless @attachment.blank?
  end

  def org_validate_discussion_post
    fail_organization_validation if @discussion_post.submission.project.course.organization != @current_organization unless @discussion_post.blank?
  end

  def org_validate_user
    @user.organization = @current_organization if @user.organization.blank? unless @user.blank?
    fail_organization_validation if @user.organization != @current_organization unless @user.blank?
  end

  def org_new_user
    @user = @current_organization.users.build()
  end

  def org_validate_course_request
    fail_organization_validation if @course_request.evaluator.organization != @current_organization unless @course_request.blank?
  end

  def org_validate_evaluation
    fail_organization_validation if @evaluation.submission.project.course.organization != @current_organization unless @evaluation.blank?
  end

  def org_validate_group
    fail_organization_validation if @group.course.organization != @current_organization unless @group.blank?
  end

  def org_validate_project
    fail_organization_validation if @project.course.organization != @current_organization unless @project.blank?
  end

  def org_validate_rubric
    fail_organization_validation if @rubric.organization != @current_organization unless @rubric.blank?
  end

  def org_validate_submission
    fail_organization_validation if @submission.project.course.organization != @current_organization unless @submission.blank?
  end

  def fail_organization_validation
    raise "Invalid Request: The requested object does not belong to the current organization"
  end

end
