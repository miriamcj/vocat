  class Exhibit

    attr_accessor :project, :submission, :creator, :course, :id
    delegate :creator, :to => :submission
    delegate :code, :to => :course, :prefix => true
    delegate :name, :to => :course, :prefix => true


    def self.find_by_course(course, options = {})
      exhibits = Array.new
      if options[:creators] == nil
        creators = User.all(:joins => :creator_courses, :conditions => {:courses_creators => {:course_id => course}})
      else
        creators = options[:creators]
      end
      if options[:projects] == nil
        projects = Project.all(:conditions => {:course_id => course})
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
            exhibit = self.new(course, creator, project, submission)
            exhibits << exhibit
          end
        end
      end
      exhibits
    end

    def self.find_by_courses(courses, options = {})
      exhibits = Array.new
      courses.each do |course|
        exhibits = exhibits + self.find_by_course(course, options)
      end
      exhibits
    end

    def self.find_by_course_and_creator(course, creator, options = {})
      options[:creators] = [ creator ]
      self.find_by_course(course, options)
    end

    def self.find_by_courses_and_creator(courses, creator, options = {})
      options[:creators] = [creator]
      exhibits = Array.new
      courses.each do |course|
        exhibits = exhibits + self.find_by_course(course, options)
      end
      exhibits
    end

    def self.find_by_course_creator_and_project(course, creator, project, options = {})
      options[:creators] = [ creator ]
      options[:projects] = [ project ]
      self.find_by_course(course, options).first
    end

    def self.find_by_course_and_project(course, project, options = {})
      options[:projects] = [ project ]
      exhibits = self.find_by_course(course, options)
    end

    def initialize(course, creator, project, submission = nil)
      @id = SecureRandom.uuid
      @course = course
      @creator = creator
      @project = project
      @submission = submission
    end

    def submission?
      !submission == nil?
    end

    def as_json(options = nil)
      {
          id: @id,
          project: ProjectSerializer.new(@project).as_json[:project],
          submission: SubmissionSerializer.new(@submission).as_json[:submission],
          creator: CreatorSerializer.new(@creator).as_json[:creator],
          course: CourseSerializer.new(@course).as_json[:course],
      }
    end



  end