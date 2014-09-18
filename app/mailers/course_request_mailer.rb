class CourseRequestMailer < ActionMailer::Base
  default from: "do-not-reply@app.vocat.io"

  def create_notify_email(course_request)
    @course_request = course_request
    mail(to: 'lucas@castironcoding.com', subject: 'A course request has been submitted')
  end

  def approve_notify_email(course_request)
    @course_request = course_request
    mail(to: 'lucas@castironcoding.com', subject: 'A course request has been submitted')
  end

  def deny_notify_email(course_request)
    @course_request = course_request
    mail(to: 'lucas@castironcoding.com', subject: 'A course request has been submitted')
  end
end
