class VideoSerializer < ActiveModel::Serializer
  attributes :id,
             :submission_id,
             :created_at,
             :source,
             :source_id,
             :locations,
             :state,
             :annotations_count,
             :thumb

  def locations
    object.locations
  end

  def created_at
    object.created_at.strftime('%B %e, %Y at %l:%M %p')
  end

  def thumb
    object.thumb
  end

end
