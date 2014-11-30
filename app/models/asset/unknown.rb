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
