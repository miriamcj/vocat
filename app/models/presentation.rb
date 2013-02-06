class Presentation < ActiveRecord::Base
  attr_accessible :description, :name, :video
  has_attached_file :video,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :bucket => Rails.configuration.s3_bucket,
                    :path => ":attachment/:year/:month/:day/:hash.:extension",
                    :hash_secret => "+hequ!ckbr0wnf@Xjump5o^3rThe1azyd0g"

  Paperclip.interpolates(:year)  {|attachment, style| attachment.instance.created_at.year }
  Paperclip.interpolates(:month) {|attachment, style| attachment.instance.created_at.month }
  Paperclip.interpolates(:day)   {|attachment, style| attachment.instance.created_at.day }

  validates :video, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :video
end
