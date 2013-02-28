  class Exhibit

    attr_accessor :project, :submission, :creator, :course_name

    def self.find_by_course(course, creators = nil)
      exhibits = Array.new
      if creators == nil
        creators = User.all(:joins => :creator_courses, :conditions => {:courses_creators => {:course_id => course}})
      end
      projects = Project.all(:conditions => {:course_id => course})
      submissions = Submission.all(:conditions => {:project_id => projects.map{ |project| project.id }})
      creators.each do |creator|
        projects.each do |project|
          submission = submissions.find {|submission| submission.project == project && submission.creator == creator }
          exhibit = self.new(course, creator, project, submission)
          exhibits << exhibit
        end
      end
      exhibits
    end

    def self.find_by_courses(courses)
      exhibits = Array.new
      courses.each do |course|
        exhibits = exhibits + self.find_by_course(course)
      end
      exhibits
    end

    def self.find_by_courses_and_creator(courses, creator)
      creators = [ creator ]
      exhibits = Array.new
      courses.each do |course|
        exhibits = exhibits + self.find_by_course(course, creators)
      end
      exhibits

    end

    def self.find_by_student
      # Not yet implemented
    end

    def self.find_by_project
      # Not yet implemented
    end

    def initialize(course, creator, project, submission = nil)
      @course = course
      @creator = creator
      @project = project
      @submission = submission
    end

    # We should delegate some methods on the exhibit to the underlying course, creator, project, and submission
    # instead of making explicit methods here. I just did it this way because I was short on time. --ZD
    def course_name
      "#{@course.department} #{@course.number}: #{@course.name}"
    end

    def submission?
      !submission == nil?
    end

    def creator_name
      @creator.name
    end

    def project_name
      @project.name
    end

  end