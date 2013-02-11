class AssignmentSubmission < ActiveRecord::Base
  attr_accessible :name, :summary
  has_many :attachments
end
