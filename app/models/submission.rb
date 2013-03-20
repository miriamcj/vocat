class Submission < ActiveRecord::Base
  attr_accessible :name, :summary, :attachments, :url, :thumb
  has_many :attachments, :as => :fileable
  belongs_to :project
  belongs_to :creator, :class_name => "User"

  def transcoded_attachment
    self.attachments.where(:transcoding_status => 1).first
  end

  def transcoded_attachment?
    self.transcoded_attachment != nil ? true : false
  end

  def url
    if self.transcoded_attachment?
      return transcoded_attachment.url
    end
    return false
  end

  def thumb
    if self.transcoded_attachment?
      return transcoded_attachment.url(:thumb)
    end
    return false
  end


end
