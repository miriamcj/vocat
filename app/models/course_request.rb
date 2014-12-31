class CourseRequest < ActiveRecord::Base

  belongs_to :evaluator, :class_name => 'User'
  belongs_to :admin, :class_name => 'User'
  belongs_to :course
  belongs_to :semester

  delegate :name, :email, to: :evaluator, prefix: true

  after_create :notify

  validates :name, :number, :year, :department, :semester_id, :section, :presence => true

  def to_course
    copy_attributes = [:name, :number, :year, :department, :semester, :section]
    course = Course.create do |c|
       copy_attributes.each { |a| c.send(a.to_s + "=", self.send(a)) }
    end
    course.enroll(evaluator, 'evaluator')
    course.save
    course
  end

  state_machine :state, :initial => :pending do
    state :pending
    state :approved
    state :denied

    event :deny do
      transition :pending => :denied
    end

    event :approve do
      transition :pending => :approved
    end

    before_transition :pending => :denied, :do => :handle_denied
    before_transition :pending => :approved, :do => :handle_approved
  end

  def handle_denied
    save
    CourseRequestMailer.deny_notify_email(self).deliver
  end

  def handle_approved
    course = to_course
    save
    CourseRequestMailer.approve_notify_email(self).deliver
  end

  def notify
    CourseRequestMailer.create_notify_email(self).deliver
  end
end
