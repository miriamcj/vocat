class VideoSerializer < ActiveModel::Serializer
  attributes :id,
             :submission_id,
             :source,
             :source_id,
             :locations,
             :state

  def locations
    object.locations
  end

  def thumb
    object.thumb
  end

end
