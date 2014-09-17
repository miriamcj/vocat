class CourseRequest < ActiveRecord::Base
  belongs_to :evaluator, :class_name => 'User', :foreign_key => 'evaluator_id'
  belongs_to :admin, :class_name => 'User', :foreign_key => 'admin_id'
  belongs_to :course
end
