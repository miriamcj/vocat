class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :creator_ids, :course_id

end
