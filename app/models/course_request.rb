class CourseRequest < ActiveRecord::Base

  belongs_to :evaluator, :class_name => 'User'
  belongs_to :admin, :class_name => 'User'
  belongs_to :course
  belongs_to :semester

  state_machine :initial => :pending do
    state :approved
    state :denied
   end

    validates :name, :number, :year, :department, :semester_id, :section, :presence => true
end
