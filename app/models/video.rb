class Video < ActiveRecord::Base

  has_one :attachment, :as => :fileable
  belongs_to :submission
  has_many :annotations, :dependent => :destroy

  delegate :url, :to => :attachment, :prefix => true, :allow_nil => true
  delegate :thumb, :to => :attachment, :prefix => true, :allow_nil => true
  delegate :transcoding_status, :to => :attachment, :prefix => true, :allow_nil => true

  attr_accessible :source_id, :source_url, :source_key, :submission_id, :thumbnail_url

  include ActiveModel::ForbiddenAttributesProtection
  accepts_nested_attributes_for :attachment

  default_scope includes(:attachment)

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

  def thumb
    case source
      when 'youtube'
        "http://img.youtube.com/vi/#{source_id}/default.jpg"
      when 'vimeo'
        thumbnail_url
      when 'attachment'
        attachment.url(:thumb)
    end
  end

  attr_accessible :url, :source_id, :source_url, :source, :submission_id, :name, :attachment_attributes

end
