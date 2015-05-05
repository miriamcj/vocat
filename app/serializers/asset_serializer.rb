# == Schema Information
#
# Table name: assets
#
#  id                :integer          not null, primary key
#  type              :string
#  name              :string
#  author_id         :integer
#  submission_id     :integer
#  listing_order     :integer
#  external_location :string
#  external_source   :string
#  created_at        :datetime
#  updated_at        :datetime
#

class AssetSerializer < ActiveModel::Serializer
  attributes :id, :family, :type, :name, :created_at, :attachment_state, :thumbnail, :locations, :created_at, :file_info,
             :listing_order, :submission_id, :creator_type, :project_id, :creator_id, :annotations_count

  has_one :attachment
  has_many :annotations

  def created_at
    object.created_at.strftime("%b %d %Y")
  end

end
