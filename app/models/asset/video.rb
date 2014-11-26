class Asset::Video < Asset

  def family
    :video
  end

  def thumbnail
    attachment.thumb
  end

  def locations
    attachment.locations
  end

  def state
    attachment.state
  end

end
