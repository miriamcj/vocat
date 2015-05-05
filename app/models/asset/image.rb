class Asset::Image < Asset

  delegate :state, :to => :attachment, :prefix => true, :allow_nil => true

  def family
    :image
  end

  def locations
    if attachment
      attachment.locations
    else
      {}
    end
  end

end
