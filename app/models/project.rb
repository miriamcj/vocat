class Project < ActiveRecord::Base
  belongs_to :course
  belongs_to :project_type
  has_many :submissions
  has_many :submitors, :through => :course
  attr_accessible :description, :name, :course


  def submission_by_user(user)
    submissions.where(:creator_id => user.id).first
  end

  def allows_peer_review()
    # TODO: Replace this with a project configuration check
    return true
  end

	def to_s()
		self.name
	end

end
