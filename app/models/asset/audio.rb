class Asset::Audio < Asset

  delegate :state, :to => :attachment, :prefix => true

  def family
    :audio
  end


end
