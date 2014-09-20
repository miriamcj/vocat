class CourseRequest < ActiveRecord::Base

  belongs_to :evaluator, :class_name => 'User'
  belongs_to :admin, :class_name => 'User'
  belongs_to :course
  belongs_to :semester

  delegate :name, :email, to: :evaluator, prefix: true

  after_create :notify

  validates :name, :number, :year, :department, :semester_id, :section, :presence => true

  def to_course
    Course.create do |c|
      attribute_names = [:name, :number, :year, :department, :semester_id, :section, :evaluator_id]
      attribute_names.each do |a|
        c.attributes = { a => attribute(a) }
      end
    end
  end

  def evaluator_email
    "lucas@castironcoding.com"
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
    CourseRequestMailer.deny_notify_email(self).deliver
    save
  end

  def handle_approved
     CourseRequestMailer.approve_notify_email(self).deliver
     save
  end

  def notify
    CourseRequestMailer.create_notify_email(self).deliver
  end
end
