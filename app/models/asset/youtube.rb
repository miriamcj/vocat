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

class Asset::Youtube < Asset

  def family
    :video
  end

  def thumbnail
    "http://img.youtube.com/vi/#{external_location}/mqdefault.jpg"
  end

  def locations
    {
        'url' => "http://www.youtube.com/watch?v=#{external_location}"
    }
  end

  def attachment_state
    'processed'
  end

  def file_info
    "Youtube #{family.capitalize}"
  end

end
