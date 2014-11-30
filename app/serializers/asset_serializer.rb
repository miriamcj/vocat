class AssetSerializer < ActiveModel::Serializer
  attributes :id, :family, :name, :created_at, :attachment_state, :thumbnail, :locations, :created_at, :file_info,
             :listing_order

  has_one :attachment

  def created_at
    object.created_at.strftime("%b %d %Y")
  end

end
