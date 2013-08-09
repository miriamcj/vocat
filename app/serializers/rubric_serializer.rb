class RubricSerializer < ActiveModel::Serializer
  attributes  :id, :name, :fields, :ranges, :cells, :high_score, :points_possible, :description



  def fields
    out = []
    object.fields.each do |key, field|
      field['id'] = key
      out << field
    end
    out
  end

  def ranges
    out = []
    object.ranges.each do |key, range|
      range['id'] = key
      out << range
    end
    out
  end

  def cells
    out = []
    object.cells.each do |key, cell|
      cell['id'] = key
      out << cell
    end
    out
  end



end
