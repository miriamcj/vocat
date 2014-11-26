class AssetSerializer < ActiveModel::Serializer
  attributes :id, :family, :name, :created_at, :attachment_state, :thumbnail, :locations, :created_at

  has_one :attachment

  def created_at
    object.created_at.strftime("%b %d %Y")
  end

end
