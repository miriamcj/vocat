# == Schema Information
#
# Table name: annotations
#
#  id               :integer          not null, primary key
#  body             :text
#  smpte_timecode   :string(255)
#  published        :boolean
#  seconds_timecode :float
#  author_id        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  asset_id         :integer
#  canvas           :text
#

class Annotation < ActiveRecord::Base

  belongs_to :asset
  belongs_to :author, :class_name => "User"

  default_scope { order('seconds_timecode ASC') }

  scope :by_course, ->(course) {
    joins(:asset => {:submission => :project}).where(:projects => {:course_id => course.id}) unless course.nil?
  }

  delegate :name, :to => :author, :prefix => true

  validates_presence_of :seconds_timecode, :author_id, :asset_id
  validates_numericality_of :seconds_timecode

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
