# == Schema Information
#
# Table name: course_requests
#
#  id              :integer          not null, primary key
#  name            :string
#  department      :string
#  section         :string
#  number          :string
#  year            :integer
#  semester_id     :integer
#  evaluator_id    :integer
#  state           :string
#  admin_id        :integer
#  course_id       :integer
#  created_at      :datetime
#  updated_at      :datetime
#  organization_id :integer
#

class CourseRequest < ApplicationRecord

  belongs_to :evaluator, :class_name => 'User'
  belongs_to :admin, optional: true, :class_name => 'User'
  belongs_to :course, optional: true
  belongs_to :semester
  belongs_to :organization

  delegate :name, :email, to: :evaluator, prefix: true
  delegate :year, to: :semester

  after_create :notify
  before_create :set_year

  validates :name, :year, :number, :department, :semester_id, :section, :presence => true

  def to_course
    copy_attributes = [:name, :number, :year, :department, :semester, :section, :organization]
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

  def set_year
    year = semester.year
  end

  def handle_denied
    save
    CourseRequestMailer.deny_notify_email(self).deliver_later
  end

  def handle_approved
    course = to_course
    save
    CourseRequestMailer.approve_notify_email(self).deliver_later
  end

  def notify
    CourseRequestMailer.create_notify_email(self).deliver_later
  end
end
