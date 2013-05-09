class Group < ActiveRecord::Base
  attr_accessible :course_id, :name
  belongs_to :course

end
