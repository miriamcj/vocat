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
