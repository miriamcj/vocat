class Asset::Image < Asset

  delegate :state, :to => :attachment, :prefix => true

  def family
    :image
  end

  def locations
    attachment.locations
  end

end
