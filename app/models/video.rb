class Video < ActiveRecord::Base

#  has_one :attachment, :as => :fileable

  has_one :attachment

  belongs_to :submission
  has_many :annotations, :dependent => :destroy

  delegate :processing_error, :to => :attachment, :prefix => false, :allow_nil => true
  delegate :url, :to => :attachment, :prefix => true, :allow_nil => true

#  accepts_nested_attributes_for :attachment

  default_scope { includes(:attachment) }

  before_save :get_vimeo_thumb

  def active_model_serializer
    VideoSerializer
  end

  def get_vimeo_thumb
    if source == 'vimeo' && thumbnail_url.nil?
      vimeo_video_json_url = "http://vimeo.com/api/v2/video/%s.json" % source_id
      self.thumbnail_url = JSON.parse(open(vimeo_video_json_url).read).first['thumbnail_large'] rescue nil
    end
  end

  def self.count_by_course(course)
    submissions = Submission.for_courses(course).pluck(:id)
    Video.where(:submission_id => submissions).count()
  end

  def state
    if attachment
      attachment.state
    elsif source && source_id
      'processed'
    end
  end

  def thumb
    case source
      when 'youtube'
        "http://img.youtube.com/vi/#{source_id}/mqdefault.jpg"
      when 'vimeo'
        thumbnail_url
      when 'attachment'
        attachment.thumb
    end
  end


end
