# Create the semesters
puts "Create Fall Semester"
Semester.find_or_create_by(:name => 'Fall', position: 1)
puts "Create Winter Semester"
Semester.find_or_create_by(:name => 'Winter', position: 2)
puts "Create Spring Semester"
Semester.find_or_create_by(:name => 'Spring', position: 3)
puts "Create Summer Semester"
Semester.find_or_create_by(:name => 'Summer', position: 4)

count = Doorkeeper::Application.where(:name => "Vocat").count
if count == 0
  puts "Create oAuth Application for Vocat"
  application = Doorkeeper::Application.new :name => "Vocat", :redirect_uri => "http://vocat.io"
  application.save
else
  puts "Found Vocat oAuth Application"
end
