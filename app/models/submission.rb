class Submission < ActiveRecord::Base
  attr_accessible :name, :summary
  has_many :attachments, :as => :fileable
  belongs_to :assignment
end
