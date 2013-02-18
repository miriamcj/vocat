# Set the random seed so we get a predictable outcome
srand 1234

# Create developer user accounts
for name in %w(alex gabe lucas peter scott zach)
  User.create(:email => "#{name}@castironcoding.com", :password => "chu88yhands", :role => "admin")
end

# Create sample strings
lorem = "Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Maecenas sed diam eget risus varius blandit sit amet non magna. Aenean lacinia bibendum nulla sed consectetur."
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
3.times { |i| instructors << User.new(:email => "instructor#{i}@test.com", :password => "chu88yhands", :role => "instructor") }
5.times { |i| helpers << User.new(:email => "helper#{i}@test.com", :password => "chu88yhands", :role => "helper") }
25.times { |i| students << User.new(:email => "student#{i}@test.com", :password => "chu88yhands", :role => "student") }

# Each course gets 1 instructor, 2 helpers, and 6 to 10 students
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

  rand(6..10).times do |i|
    course.users << students[i]
    CourseRole.set_role(students[i], course, :student)
  end

end

# Create an instructor that is also a student
instructor = User.new(:email => "assistant_instructor@test.com", :password => "chu88yhands", :role => "instructor")
course = courses.sample
course.users << instructor
CourseRole.set_role(instructor, course, :student)
