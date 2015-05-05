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

class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :creator_ids, :course_id, :first_name, :members

  def first_name
    object.name
  end

  def members
    object.creator_names
  end

end
