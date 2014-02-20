class VideoSerializer < ActiveModel::Serializer
  attributes :id,
             :submission_id,
             :source,
             :source_id,
             :attachment_url,
             :thumb,
             :state

  def thumb
    object.thumb
  end

end
