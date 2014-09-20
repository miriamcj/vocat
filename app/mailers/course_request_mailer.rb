class CourseRequestMailer < ActionMailer::Base
  default from: Rails.application.config.vocat.email.default_from

  def create_notify_email(course_request)
    @course_request = course_request
    mail(to: Rails.application.config.vocat.email.notification.course_request_create, subject: 'A course request has been submitted')
  end

  def approve_notify_email(course_request)
    @course_request = course_request
    mail(to: course_request.evaluator_email, subject: 'Your course request has been approved')
  end

  def deny_notify_email(course_request)
    @course_request = course_request
    mail(to: course_request.evaluator_email, subject: 'Your course request has been denied')
  end
end
