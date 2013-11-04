class Annotation < ActiveRecord::Base

  belongs_to :video
  belongs_to :author, :class_name => "User"

  default_scope { order('seconds_timecode ASC') }

  scope :by_course, -> (course) {
    joins(:video => {:submission => :project}).where(:projects => {:course_id => course.id}) unless course.nil?
  }

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
