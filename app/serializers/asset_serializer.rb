class AssetSerializer < ActiveModel::Serializer
  attributes :type, :family, :name, :created_at

end
