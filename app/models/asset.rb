class Asset < ActiveRecord::Base

  include RankedModel
  ranks :listing_order, :with_same => :submission_id

  belongs_to :submission
  belongs_to  :author, :class_name => 'User'
  has_many :annotations, :dependent => :destroy
  has_one :attachment, :dependent => :destroy

  delegate :processing_error, :to => :attachment, :prefix => false, :allow_nil => true
  delegate :creator, :to => :submission, :allow_nil => true
  delegate :course, :to => :submission, :allow_nil => true
  delegate :state, :to => :attachment, :prefix => true

  # We don't want any typeless assets being created.
  validates_presence_of :type
  before_validation :ensure_type

  def family
    'unknown'
  end

  def active_model_serializer
    AssetSerializer
  end

  # Params is a hash of search values including (:creator|| :source || :state)
  def self.search(params)
    # v = Asset.all
    # v = v.where({external_source: params[:source]}) unless params[:source].blank?
    # v = v.where("videos.source != 'attachment' OR (videos.source = 'attachment' AND attachments.state = ?)", params[:state]) unless params[:state].blank?
    # v = v.joins(:submission => :user).where("users.last_name LIKE ? OR users.first_name LIKE ? OR users.email LIKE ?", "%#{params[:creator]}%", "%#{params[:creator]}%", "%#{params[:creator]}%") unless params[:creator].blank?
    # v
  end

  def annotations_count
    annotations.count
  end

  def thumbnail
    raise NotImplementedError
  end

  def locations
    raise NotImplementedError
  end

  def state
    raise NotImplementedError
  end

  protected

    def ensure_type
      if attachment
        attachment_type = Attachment::Inspector.attachmentToType(attachment)
        self.type = "Asset::#{attachment_type.to_s.capitalize}"
      elsif external_location
        case external_location
          when 'youtube'
            self.type = 'Asset::Youtube'
          when 'vimeo'
            self.type = 'Asset::Vimeo'
        end
      else
        self.type = 'Asset::Unknown'
      end
    end

end
