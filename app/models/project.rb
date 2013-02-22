class Project < ActiveRecord::Base
  belongs_to :course
  belongs_to :project_type
  has_many :submissions
  attr_accessible :description, :name
end
