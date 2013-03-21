class Exhibit
  module Find
    def self.by_course(course, options = {})
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
            exhibit = Exhibit.new(course, creator, project, submission)
            exhibits << exhibit
          end
        end
      end
      exhibits
    end

    def self.by_courses(courses, options = {})
      exhibits = Array.new
      courses.each do |course|
        exhibits = exhibits + self.by_course(course, options)
      end
      exhibits
    end

    def self.by_course_and_creator(course, creator, options = {})
      options[:creators] = [ creator ]
      self.by_course(course, options)
    end

    def self.by_courses_and_creator(courses, creator, options = {})
      options[:creators] = [creator]
      exhibits = Array.new
      courses.each do |course|
        exhibits = exhibits + self.by_course(course, options)
      end
      exhibits
    end

    def self.by_course_creator_and_project(course, creator, project, options = {})
      options[:creators] = [ creator ]
      options[:projects] = [ project ]
      self.by_course(course, options).first
    end

    def self.by_course_and_project(course, project, options = {})
      options[:projects] = [ project ]
      exhibits = self.by_course(course, options)
    end
  end
end