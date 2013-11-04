class Group < ActiveRecord::Base

  belongs_to :course
  has_many :submissions, :as => :creator, :dependent => :destroy
  has_and_belongs_to_many :creators, :class_name => "User", :join_table => "groups_creators"

  def active_model_serializer
    GroupSerializer
  end

end
