class Assignment < ActiveRecord::Base
  belongs_to :course
  belongs_to :assignment_type
  has_many :submissions
  attr_accessible :description, :name
end
