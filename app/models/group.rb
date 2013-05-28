class Group < ActiveRecord::Base
  attr_accessible :course_id, :name
  belongs_to :course
  has_and_belongs_to_many :creators, :class_name => "User", :join_table => "groups_creators"
end
