class RubricSerializer < ActiveModel::Serializer
  attributes  :id, :name, :fields, :ranges, :cells, :high_score, :points_possible, :description

end
