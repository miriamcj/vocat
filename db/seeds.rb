# Set the random seed so we get a predictable outcome
srand 1234

# Create sample sections
def random_section
  rand(36**5).to_s(36).upcase
end

def random_name
  "#{Faker::Name.first_name} #{Faker::Name.last_name}"
end

# Create the organizations
baruch  = Organization.create(:name => "Baruch College")
other   = Organization.create(:name => Faker::Company.name)

# Create developer user accounts
for name in %w(alex gabe lucas peter scott zach)
  u = User.create(:email => "#{name}@castironcoding.com", :password => "chu88yhands", :role => "admin", :name => name)
  u.organization = baruch
  u.save
end

# Create the courses
courses = Array.new
courses << baruch.courses.create(:name => "Data Structures", :department => "CS", :number => "163", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Programming Systems", :department => "CS", :number => "201", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Systems Programming", :department => "CS", :number => "202", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Discrete Structures I", :department => "CS", :number => "250", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Discrete Structures II", :department => "CS", :number => "251", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "AI: Combinatorial Search", :department => "CS", :number => "443", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Shakespeare", :department => "ENG", :number => "201", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Survey of English Literature I", :department => "ENG", :number => "204", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Survey of English Literature II", :department => "ENG", :number => "205", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Introduction to Literature", :department => "ENG", :number => "100", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Introduction to World Literature", :department => "ENG", :number => "108", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Native American Women Writers", :department => "ENG", :number => "367U", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Practical Grammar", :department => "ENG", :number => "425", :section => random_section, :description => Faker::Lorem.paragraph)


# Create sample users
instructors = Array.new
helpers = Array.new
students = Array.new

6.times do |i|
  u = User.new(:email => "instructor#{i}@test.com", :password => "chu88yhands", :role => "instructor", :name => random_name)
  u.organization = baruch
  u.save
  instructors << u
end

15.times do |i|
  u = User.new(:email => "helper#{i}@test.com", :password => "chu88yhands", :role => "student", :name => random_name)
  u.organization = baruch
  u.save
  helpers << u
end

150.times do |i|
  u = User.new(:email => "student#{i}@test.com", :password => "chu88yhands", :role => "student", :name => random_name)
  u.organization = baruch
  u.save
  students << u
end


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
    assignment = course.assignments.create(:name => Faker::Lorem.sentence(rand(6..15)), :description => Faker::Lorem.paragraph)
    assignment.assignment_type = presentation
    assignment.save

    rand(3..5).times do
      submission = assignment.submissions.create(:name =>Faker::Lorem.sentence(rand(2..5)), :summary => Faker::Lorem.paragraph )

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
instructor = User.new(:email => "assistant_instructor@test.com", :password => "chu88yhands", :role => "instructor", :name => random_name)
instructor.organization = baruch
instructor.save
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

