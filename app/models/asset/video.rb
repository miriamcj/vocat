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

class Asset::Video < Asset

  delegate :state, :to => :attachment, :prefix => true

  def family
    :video
  end

  def locations
    attachment.locations
  end

  def state
    attachment.state
  end

end
