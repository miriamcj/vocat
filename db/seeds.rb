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
  u = User.create(:email => "#{name}@castironcoding.com", :password => "chu88yhands", :name => name)
  u.role = "admin"
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
evaluators = Array.new
assistants = Array.new
creators = Array.new

6.times do |i|
  u = User.new(:email => "evaluator#{i}@test.com", :password => "chu88yhands", :name => random_name)
  u.organization = baruch
  u.role = "evaluator"
  u.save
  evaluators << u
end

15.times do |i|
  u = User.new(:email => "assistant#{i}@test.com", :password => "chu88yhands", :name => random_name)
  u.organization = baruch
  u.role = "creator"
  u.save
  assistants << u
end

150.times do |i|
  u = User.new(:email => "creator#{i}@test.com", :password => "chu88yhands", :name => random_name)
  u.role = "creator"
  u.organization = baruch
  u.save
  creators << u
end


# Create an project type
presentation = ProjectType.new(:name => "Presentation")

# Each course gets 1 evaluator, 2 assistants, 15 to 30 creators, and 2 to 10 projects
#
# SQL for finding number of courses per creator:
# select user_id, email, count(*) from courses_creators inner join users on users.id=courses_creators.user_id group by user_id;
#
courses.each do |course|

  evaluators.shuffle!
  assistants.shuffle!
  creators.shuffle!

  course.evaluators << evaluators[0]
  course.assistants << assistants[0..2]
  course.creators << creators[0..rand(10..15)]

  course.save

  rand(1..4).times do
    project = course.projects.create(:name => Faker::Company.bs.split(' ').map(&:capitalize).join(' '), :description => Faker::Lorem.paragraph)
    project.project_type = presentation
    project.save

    course_creators = course.creators
    course_creators.shuffle!

    rand(0..(course_creators.length - 1)).times do |i|
      # Most creators submit a project
      if rand > 0.2
        submission = project.submissions.create(:name => Faker::Lorem.words(rand(2..5)).map(&:capitalize).join(' '), :summary => Faker::Lorem.paragraph )
        insert = "INSERT INTO attachments (media_file_name, media_content_type, media_file_size, media_updated_at, transcoding_status, created_at, updated_at, fileable_id, fileable_type) "
        if rand > 0.5
          values = "VALUES ('sample_mpeg5.mp4', 'vidoe/mp4', '245779', '2013-02-20 23:43:11', '1', '2013-02-20 23:43:11', '2013-02-20 23:43:11', '#{submission.id}', 'Submission')"
        else
          values = "VALUES ('MVI_5450.AVI', 'video/avi', '1425522', '2013-02-20 23:42:21', '1', '2013-02-20 23:42:21', '2013-02-20 23:42:21', '#{submission.id}', 'Submission')"
        end
        ActiveRecord::Base.connection.execute "#{insert}#{values}"
        submission.creator = course_creators[i]
        submission.save!
      end
    end
  end

end

# Create an evaluator that is both a creator for a course and an evaluator for a course
evaluator = User.new(:email => "assistant_evaluator@test.com", :password => "chu88yhands", :name => random_name)
evaluator.organization = baruch
evaluator.role = "evaluator"
evaluator.save
course = courses.sample
course.creators << evaluator

course2 = courses.sample
loop do
  break unless course == course2
  course2 = courses.sample
end

course2.evaluators << evaluator


