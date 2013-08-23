class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :creator_ids, :course_id, :first_name

  def first_name
    object.name
  end

end
