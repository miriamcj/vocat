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

class Asset::Unknown < Asset

  delegate :state, :to => :attachment, :prefix => true, :allow_nil => true

  def family
    :unknown
  end

  def thumbnail
    nil
  end

  def locations
    {}
  end

end
