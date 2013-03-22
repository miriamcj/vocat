require 'exhibit/find.rb'

class Exhibit

  attr_accessor :project, :submission, :creator, :course, :id
  delegate :code, :to => :course, :prefix => true
  delegate :name, :to => :course, :prefix => true

  # Find methods are broken out into a module to better separate concerns
  include Exhibit::Find

  def initialize(viewer, course, creator, project, submission = nil)
    @id = SecureRandom.uuid
    @viewer = viewer
    @course = course
    @creator = creator
    @project = project
    @submission = submission
  end

  def submission?
    !submission == nil?
  end

  # The only information we currently need about the viewer on the frontend
  # is the viewer's abilities
  def serialize_viewer
    {
      :can_update => @submission && @viewer.can?(:update, @submission),
      :is_owner => @submission && @viewer.can?(:own, @submission),
      :can_evaluate => @project && @viewer.can?(:evaluate, @project)
    }
  end

  def as_json(options = nil)
    {
      :id => @id,
      :viewer => self.serialize_viewer,
      :project => ProjectSerializer.new(@project).as_json[:project],
      :submission => SubmissionSerializer.new(@submission).as_json[:submission],
      :creator => CreatorSerializer.new(@creator).as_json[:creator],
      :course => CourseSerializer.new(@course).as_json[:course]
    }
  end



end