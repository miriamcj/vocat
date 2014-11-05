class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :creator_ids, :course_id, :first_name, :members

  def first_name
    object.name
  end

  def members
    object.creator_names
  end

end
