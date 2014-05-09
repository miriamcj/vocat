class Video < ActiveRecord::Base

  belongs_to :submission
  has_one :attachment, :dependent => :destroy
  has_many :annotations, :dependent => :destroy
  delegate :processing_error, :to => :attachment, :prefix => false, :allow_nil => true
  delegate :creator, :to => :submission, :allow_nil => true
  delegate :course, :to => :submission, :allow_nil => true

  SOURCES = %w(attachment vimeo youtube)

  validates_inclusion_of :source, :in => Video::SOURCES
  before_save :get_vimeo_thumb

  default_scope { includes(:attachment) }

  def active_model_serializer
    VideoSerializer
  end

  def locations
    case source
      when 'youtube'
        {
            'url' => "http://www.youtube.com/watch?v=#{source_id}"
        }
      when 'vimeo'
        {
            'url' => "http://vimeo.com/#{source_id}"
        }
      when 'attachment'
        attachment.locations
    end
  end

  # Params is a hash of search values including (:creator|| :source || :state)
  def self.search(params)
    v = Video.all
    v = v.where({source: params[:source]}) unless params[:source].blank?
    v = v.where("videos.source != 'attachment' OR (videos.source = 'attachment' AND attachments.state = ?)", params[:state]) unless params[:state].blank?
    v = v.joins(:submission => :user).where("users.last_name LIKE ? OR users.first_name LIKE ? OR users.email LIKE ?", "%#{params[:creator]}%", "%#{params[:creator]}%", "%#{params[:creator]}%") unless params[:creator].blank?
    v
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

  # TODO: Another candidate for STI instead of this half-ass STI.
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
