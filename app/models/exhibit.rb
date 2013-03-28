require 'exhibit/find.rb'

class Exhibit

  attr_accessor :project, :submission, :creator, :course, :id
  delegate :code, :to => :course, :prefix => true
  delegate :name, :to => :course, :prefix => true

  def self.find_exhibits(options = {})
    viewer = options[:viewer]
    course = options[:course]
    creator = options[:creator]
    project = options[:project]

    # Project is the backbone of this search because we will return
    # one exhibit for every project in a course in which the creator
    # is enrolled.
    if project == nil
      if course == nil
        if creator != nil
          course = Course.all(:joins => :creator_courses, :conditions => {:courses_creators => {:creator_id => creator}})
        else
          # Throw exception
        end
      end

      # course should no longer be nil
      project =  Project.all(:conditions => {:course_id => options[:course]})
      if creator == nil
        creator = User.all(:joins => :creator_courses, :conditions => {:courses_creators => {:course_id => course}})
      end



    end



    myvar = 1


  end

  def self.find_by_course(options = {})
    exhibits = Array.new
    if options[:creators] == nil
      creators = User.all(:joins => :creator_courses, :conditions => {:courses_creators => {:course_id => options[:course]}})
    else
      creators = options[:creators]
    end
    if options[:projects] == nil
      projects = Project.all(:conditions => {:course_id => options[:course]})
    else
      projects = options[:projects]
    end
    submissions = Submission.all(:conditions => {:project_id => projects.map{ |project| project.id }})
    creators.each do |creator|
      projects.each do |project|
        create_exhibit = true
        submission = submissions.find {|submission| submission.project == project && submission.creator == creator }
        create_exhibit = false if options[:require_submissions] and submission.nil?

        if create_exhibit == true
          exhibit = self.factory(options[:viewer], options[:course], creator, project, submission)
          exhibits << exhibit
        end
      end
    end
    exhibits
  end




  #def self.by_course_and_creator(viewer, course, creator, options = {})
  #  options[:creators] = [ creator ]
  #  self.by_course(viewer, course, options)
  #end
  #
  #def self.by_courses_and_creator(viewer, courses, creator, options = {})
  #  options[:creators] = [creator]
  #  exhibits = Array.new
  #  courses.each do |course|
  #    exhibits = exhibits + self.by_course(viewer, course, options)
  #  end
  #  exhibits
  #end
  #
  #def self.by_course_creator_and_project(viewer, course, creator, project, options = {})
  #  options[:creators] = [ creator ]
  #  options[:projects] = [ project ]
  #  self.by_course(viewer, course, options).first
  #end
  #
  #def self.by_course_and_project(viewer, course, project, options = {})
  #  options[:projects] = [ project ]
  #  exhibits = self.by_course(viewer, course, options)
  #end


  def self.find_by_courses(options = {})
    exhibits = Array.new
    options[:courses].each do |course|
      options[:course] = course
      exhibits = exhibits + self.find_by_course(options)
    end
    exhibits
  end

  def self.factory (viewer, course, creator, project, submission)
    Exhibit.new(viewer, course, creator, project, submission)
  end

  def self.find_by_creator(options = {})
    options[:courses] = options[:creator].courses
    self.find_by_courses(options)
  end


  def self.find_by_creator_and_project(options = {})
    submission = Submission.where({:project_id => options[:project], :creator_id => options[:creator]}).first
    course = project.course
    self.factory(options[:viewer], course, options[:creator], options[:project], submission)
  end


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