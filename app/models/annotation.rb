class Annotation < ActiveRecord::Base
  attr_accessible :attachment_id, :author_id, :body, :published, :seconds_timecode, :smpte_timecode
  belongs_to :attachment
  belongs_to :author, :class_name => "User"

  default_scope order('seconds_timecode ASC')

  delegate :name, :to => :author, :prefix => true

  validates_presence_of :body, :seconds_timecode, :author_id, :attachment_id
  validates_numericality_of :seconds_timecode
  validates_length_of :body, :minimum => 3

  def active_model_serializer
    AnnotationSerializer
  end
end
