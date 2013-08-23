class Group < ActiveRecord::Base
  attr_accessible :course_id, :name, :creator_ids
  belongs_to :course

  has_many :submissions, :as => :creator

  has_and_belongs_to_many :creators, :class_name => "User", :join_table => "groups_creators"

  def active_model_serializer
    GroupSerializer
  end

end
