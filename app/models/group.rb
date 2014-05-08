class Group < ActiveRecord::Base

  belongs_to :course
  has_many :submissions, :as => :creator, :dependent => :destroy
  has_and_belongs_to_many :creators, :class_name => "User", :join_table => "groups_creators"

  def active_model_serializer
    GroupSerializer
  end

  def creator_type
    "Group"
  end

  def is_group?
    false
  end

  def is_user?
    true
  end

  def to_s
    name
  end

end
