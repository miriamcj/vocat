class CourseSerializer < ActiveModel::Serializer
  attributes :id, :department, :description, :name, :number, :section
end
