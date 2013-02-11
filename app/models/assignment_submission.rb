class AssignmentSubmission < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :attachments
end
