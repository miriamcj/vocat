class Submission < ActiveRecord::Base
  attr_accessible :name, :summary
  has_and_belongs_to_many :attachments
end
