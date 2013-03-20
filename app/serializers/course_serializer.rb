class CourseSerializer < ActiveModel::Serializer
  attributes :id, :department, :description, :name, :number, :section, :organization_id
end
