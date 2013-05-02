class AnnotationSerializer < ActiveModel::Serializer
  attributes :id, :attachment_id, :author_id, :body, :published, :seconds_timecode, :smpte_timecode, :author_name
end
