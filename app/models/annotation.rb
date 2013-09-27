class Annotation < ActiveRecord::Base
  attr_accessible :video_id,
                  :author_id,
                  :body,
                  :published,
                  :seconds_timecode,
                  :smpte_timecode
  belongs_to :video
  belongs_to :author, :class_name => "User"

  default_scope order('seconds_timecode ASC')

  delegate :name, :to => :author, :prefix => true

  validates_presence_of :body, :seconds_timecode, :author_id, :video_id
  validates_numericality_of :seconds_timecode
  validates_length_of :body, :minimum => 3

  def start_timecode
    "#{Time.at(seconds_timecode).gmtime.strftime('%R:%S')}"
  end

  def end_timecode
    "#{Time.at(seconds_timecode + 10).gmtime.strftime('%R:%S')}"
  end

  def active_model_serializer
    AnnotationSerializer
  end
end
