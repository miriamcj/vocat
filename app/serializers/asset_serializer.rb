class AssetSerializer < ActiveModel::Serializer
  attributes :id, :family, :type, :name, :created_at, :attachment_state, :thumbnail, :locations, :created_at, :file_info,
             :listing_order, :submission_id, :creator_type, :project_id, :creator_id

  has_one :attachment
  has_many :annotations

  def created_at
    object.created_at.strftime("%b %d %Y")
  end

end
