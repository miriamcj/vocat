class Exhibit < ActiveRecord::Base

  set_table_name "projects"
  attr_accessible :project, :creator, :course, :viewer
  belongs_to :course
  belongs_to :submission
  belongs_to :project
  belongs_to :creator, :class_name => "User"
  belongs_to :viewer, :class_name => "User"

  delegate :code, :to => :course, :prefix => true
  delegate :name, :to => :course, :prefix => true

  # Prevent exhibits from being modified, created, or saved
  def readonly?
    return true
  end

  # Prevent exhibits from being destroyed
  def before_destroy
    raise ActiveRecord::ReadOnlyRecord
  end

  # This
  def self.factory(options = {})

    q = Exhibit.scoped
    if options[:course]
      q = q.where(:course_id => self.options_to_ids(options[:course]))
    end

    if options[:creator]
      q = q.where('courses_creators.user_id' => self.options_to_ids(options[:creator]))
    end

    if options[:project]
      q = q.where(:id => self.options_to_ids(options[:project]))
    end

    q = q.joins(:course => :creators).joins('LEFT OUTER JOIN submissions ON submissions.project_id = projects.id AND submissions.creator_id = courses_creators.user_id')

    select = 'submissions.id as submission_id, projects.id as project_id, courses_creators.user_id as creator_id, courses_creators.course_id as course_id'
    if options[:viewer]
      select = "#{options[:viewer].id.to_s} as \"viewer_id\", " + select
    end
    q = q.select(select)

    exhibits = q.includes(:viewer, :course, :submission, :creator, :project).readonly()
  end

  def self.options_to_ids(option)
    if option.kind_of?(Array)
      option.map { |model| model.id }
    else
      [option.id]
    end
  end

  def submission?
    !submission == nil?
  end

  # The only information we currently need about the viewer on the frontend
  # is the viewer's abilities
  def serialize_viewer
    {
      :can_update => submission && viewer.can?(:update, submission),
      :is_owner => submission && viewer.can?(:own, submission),
      :can_evaluate => project && viewer.can?(:evaluate, project)
    }
  end

  def as_json(options = nil)
    {
      :id => @id,
      :viewer => self.serialize_viewer,
      :project => ProjectSerializer.new(project).as_json[:project],
      :submission => SubmissionSerializer.new(submission).as_json[:submission],
      :creator => CreatorSerializer.new(creator).as_json[:creator],
      :course => CourseSerializer.new(course).as_json[:course]
    }
  end



end