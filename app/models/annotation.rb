class Annotation < ActiveRecord::Base
  attr_accessible :attachment_id, :author_id, :body, :published, :seconds_timecode, :smpte_timecode
  belongs_to :attachment
  belongs_to :author, :class_name => "User"

  default_scope order('seconds_timecode ASC')

  delegate :name, :to => :author, :prefix => true

  def active_model_serializer
    AnnotationSerializer
  end
end
