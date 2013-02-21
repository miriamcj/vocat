# Set the random seed so we get a predictable outcome
srand 1234

# Create developer user accounts
for name in %w(alex gabe lucas peter scott zach)
  User.create(:email => "#{name}@castironcoding.com", :password => "chu88yhands", :role => "admin")
end

# Create sample strings
def lorem(size = nil)
  lorems = [
      "Aenean lacinia bibendum nulla sed consectetur. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. Vestibulum id ligula porta felis euismod semper.",
      "Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Nullam quis risus eget urna mollis ornare vel eu leo. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor.",
      "Donec ullamcorper nulla non metus auctor fringilla. Donec id elit non mi porta gravida at eget metus. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Donec sed odio dui. Morbi leo risus, porta ac consectetur ac, vestibulum at eros.",
      "Dod elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec sed odio dui. Sed posuere consectetur est at lobortis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.",
      "Cras justo odio, dapibus ac facilisis in, egestas eget quam. Maecenas sed diam eget risus varius blandit sit amet non magna. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Sed posuere consectetur est at lobortis.",
      "Nullam id dolor id nibh ultricies vehicula ut id elit. Vestibulum id ligula porta felis euismod semper. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Curabitur blandit tempus porttitor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."
  ]

  if size
    words = lorems.sample.split[0..Integer(size)].join(' ')
    unless words[-1,1] == '.'
      "#{words}."
    else
      words
    end
  else
    lorems.sample
  end
end

def random_section
  rand(36**5).to_s(36).upcase
end

# Create the organizations
baruch  = Organization.create(:name => "Baruch College")
other   = Organization.create(:name => "Some Other College")

# Create the courses
courses = Array.new
courses << baruch.courses.create(:name => "Data Structures", :department => "CS", :number => "163", :section => random_section, :description => lorem)
courses << baruch.courses.create(:name => "Programming Systems", :department => "CS", :number => "201", :section => random_section, :description => lorem)
courses << baruch.courses.create(:name => "Systems Programming", :department => "CS", :number => "202", :section => random_section, :description => lorem)
courses << baruch.courses.create(:name => "Discrete Structures I", :department => "CS", :number => "250", :section => random_section, :description => lorem)
courses << baruch.courses.create(:name => "Discrete Structures II", :department => "CS", :number => "251", :section => random_section, :description => lorem)
courses << baruch.courses.create(:name => "AI: Combinatorial Search", :department => "CS", :number => "443", :section => random_section, :description => lorem)
courses << baruch.courses.create(:name => "Shakespeare", :department => "ENG", :number => "201", :section => random_section, :description => lorem)
courses << baruch.courses.create(:name => "Survey of English Literature I", :department => "ENG", :number => "204", :section => random_section, :description => lorem)
courses << baruch.courses.create(:name => "Survey of English Literature II", :department => "ENG", :number => "205", :section => random_section, :description => lorem)
courses << baruch.courses.create(:name => "Introduction to Literature", :department => "ENG", :number => "100", :section => random_section, :description => lorem)
courses << baruch.courses.create(:name => "Introduction to World Literature", :department => "ENG", :number => "108", :section => random_section, :description => lorem)
courses << baruch.courses.create(:name => "Native American Women Writers", :department => "ENG", :number => "367U", :section => random_section, :description => lorem)
courses << baruch.courses.create(:name => "Practical Grammar", :department => "ENG", :number => "425", :section => random_section, :description => lorem)


# Create sample users
instructors = Array.new
helpers = Array.new
students = Array.new
6.times { |i| instructors << User.new(:email => "instructor#{i}@test.com", :password => "chu88yhands", :role => "instructor") }
15.times { |i| helpers << User.new(:email => "helper#{i}@test.com", :password => "chu88yhands", :role => "student") }
150.times { |i| students << User.new(:email => "student#{i}@test.com", :password => "chu88yhands", :role => "student") }

# Create an assignment type
presentation = AssignmentType.new(:name => "Presentation")

# Each course gets 1 instructor, 2 helpers, 15 to 30 students, and 2 to 10 assignments
#
# SQL for finding number of courses per student:
# select user_id, email, count(*) from course_roles inner join users on users.id=course_roles.user_id group by user_id;
#
courses.each do |course|

  instructors.shuffle!
  helpers.shuffle!
  students.shuffle!

  course.users << instructors[0]
  CourseRole.set_role(instructors[0], course, :instructor)

  2.times do |i|
    course.users << helpers[i]
    CourseRole.set_role(helpers[i], course, :helper)
  end

  rand(15..30).times do |i|
    course.users << students[i]
    CourseRole.set_role(students[i], course, :student)
  end

  rand(2..10).times do
    assignment = course.assignments.create(:name => lorem(rand(6..15)), :description => lorem)
    assignment.assignment_type = presentation
    assignment.save

    rand(3..5).times do
      submission = assignment.submissions.create(:name =>lorem(rand(2..5)), :summary => lorem )

      insert = "INSERT INTO attachments (media_file_name, media_content_type, media_file_size, media_updated_at, transcoding_status, created_at, updated_at, fileable_id, fileable_type) "
      if rand > 0.5
        values = "VALUES ('sample_mpeg5.mp4', 'vidoe/mp4', '245779', '2013-02-20 23:43:11', '1', '2013-02-20 23:43:11', '2013-02-20 23:43:11', '#{submission.id}', 'Submission')"
      else
        values = "VALUES ('MVI_5450.AVI', 'video/avi', '1425522', '2013-02-20 23:42:21', '1', '2013-02-20 23:42:21', '2013-02-20 23:42:21', '#{submission.id}', 'Submission')"
      end
      ActiveRecord::Base.connection.execute "#{insert}#{values}"
    end

  end

end

# Create an instructor that is both a student for a course and an instructor for a course
instructor = User.new(:email => "assistant_instructor@test.com", :password => "chu88yhands", :role => "instructor")
course = courses.sample
course.users << instructor
CourseRole.set_role(instructor, course, :student)

course2 = courses.sample
loop do
  break unless course == course2
  course2 = courses.sample
end

course2.users << instructor
CourseRole.set_role(instructor, course2, :instructor)

