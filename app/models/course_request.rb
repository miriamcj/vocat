class CourseRequest < ActiveRecord::Base

  belongs_to :evaluator, :class_name => 'User'
  belongs_to :admin, :class_name => 'User'
  belongs_to :course
  belongs_to :semester

  delegate :name, to: :evaluator, prefix: true

  after_create :notify


  state_machine :initial => :pending do
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

  validates :name, :number, :year, :department, :semester_id, :section, :presence => true

  def handle_denied
  end

  def handle_approved
  end

  def notify
  end



end
