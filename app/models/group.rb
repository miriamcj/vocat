# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ActiveRecord::Base

  belongs_to :course
  has_many :submissions, :as => :creator, :dependent => :destroy
  has_and_belongs_to_many :creators, :class_name => "User", :join_table => "groups_creators"

  def active_model_serializer
    GroupSerializer
  end

  def creator_names
    creators.order(last_name: :asc, first_name: :asc).map { |creator| creator.name }
  end

  def creator_type
    "Group"
  end

  def is_group?
    true
  end

  def list_name
    name
  end

  def is_user?
    false
  end

  def include?(user)
    creators.include?(user)
  end

  def to_s
    name
  end

end
