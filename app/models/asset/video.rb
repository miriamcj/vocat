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
