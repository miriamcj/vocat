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

class Asset::Vimeo < Asset

  def family
    :video
  end

  def thumbnail
    @thumbnail ||= begin
      url = "http://vimeo.com/api/v2/video/%s.json" % external_location
      JSON.parse(open(url).read).first['thumbnail_large'] rescue nil
    end
  end

  def locations
    {
        'url' => "http://vimeo.com/#{external_location}"
    }
  end

  def attachment_state
    'processed'
  end

  def file_info
    "Vimeo #{family.capitalize}"
  end


end
