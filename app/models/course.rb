class Course < ActiveRecord::Base
  belongs_to :organization
  attr_accessible :department, :description, :name, :number, :section
end
