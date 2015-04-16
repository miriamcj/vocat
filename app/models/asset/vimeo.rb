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
