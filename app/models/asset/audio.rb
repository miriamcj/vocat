class Asset::Audio < Asset

  delegate :state, :to => :attachment, :prefix => true

  def family
    :audio
  end

  def locations
    attachment.locations
  end

end
