class CourseRequestMailer < ActionMailer::Base
  default from: Rails.application.config.vocat.email.default_from

  def create_notify_email(course_request)
    @course_request = course_request
    @organization = @course_request.organization
    mail(to: @organization.email_notification_course_request, from: from(@organization), subject: 'A course request has been submitted')
  end

  def approve_notify_email(course_request)
    @course_request = course_request
    @organization = @course_request.organization
    mail(to: course_request.evaluator_email, from: from(@organization), subject: 'Your course request has been approved')
  end

  def deny_notify_email(course_request)
    @course_request = course_request
    @organization = @course_request.organization
    mail(to: course_request.evaluator_email, from: from(@organization), subject: 'Your course request has been denied')
  end

  protected

  def from(organization)
    organization.email_default_from || Rails.application.config.vocat.email.default_from
  end

end
