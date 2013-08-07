class RubricSerializer < ActiveModel::Serializer
  attributes  :id, :name, :fields, :ranges, :field_descriptions, :range_descriptions, :high_score, :points_possible, :description

  def fields
    out = {}
    object.fields.each do |key, name|
      out[key] = {
          'name' => name,
          'id' => key,
          'range_descriptions' => {}
      }
      object.ranges.each do |range_key, range_name|
        out[key]['range_descriptions'][range_key] = object.range_description(range_key, key)
      end
    end
    out
  end

  def ranges
    out = {}
    object.ranges.each do |key, name|
      out[key] = {
          'name' => name,
          'id' => key,
          'low' => object.range_low(key.to_s),
          'high' => object.range_high(key.to_s)
      }
    end
    out

  end

end
