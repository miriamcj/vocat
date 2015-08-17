class CourseRequestMailer < ActionMailer::Base
  default from: Rails.application.config.vocat.email.default_from

  def create_notify_email(course_request)
    @course_request = course_request
    @organization = @course_request.organization
    from = from(@organization)
    to = @organization.email_notification_course_request
    if to.blank? || from.blank?
      return false
    end
    mail(to: to, from: from, subject: 'A course request has been submitted')
  end

  def approve_notify_email(course_request)
    @course_request = course_request
    @organization = @course_request.organization
    from = from(@organization)
    to = course_request.evaluator_email
    if to.blank? || from.blank?
      return false
    end
    mail(to: to, from: from, subject: 'Your course request has been approved')
  end

  def deny_notify_email(course_request)
    @course_request = course_request
    @organization = @course_request.organization
    from = from(@organization)
    to = course_request.evaluator_email
    if to.blank? || from.blank?
      return false
    end

    mail(to: to, from: from, subject: 'Your course request has been denied')
  end

  protected

  def from(organization)
    organization.email_default_from || Rails.application.config.vocat.email.default_from
  end

end
