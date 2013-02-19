class Assignment < ActiveRecord::Base
  belongs_to :course
  belongs_to :assignment_type
  attr_accessible :description, :name
end
