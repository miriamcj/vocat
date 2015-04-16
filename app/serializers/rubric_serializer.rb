class RubricSerializer < ActiveModel::Serializer
  attributes :id, :name, :fields, :ranges, :cells, :low, :high, :points_possible, :description, :public
end
