# Create the semesters
puts "Create Fall Semester"
Semester.find_or_create_by(:name => 'Fall', position: 1)
puts "Create Winter Semester"
Semester.find_or_create_by(:name => 'Winter', position: 2)
puts "Create Spring Semester"
Semester.find_or_create_by(:name => 'Spring', position: 3)
puts "Create Summer Semester"
Semester.find_or_create_by(:name => 'Summer', position: 4)

puts "Create Organization: Baruch College"
org = Organization.find_or_create_by(:name => "Baruch College")

puts "Create Admin User: admin@vocat.io / testtest123"
u = User.create(:email => 'admin@vocat.io', :org_identity => rand(11111111..99999999), :password => "testtest123", :first_name => 'Vocat', :last_name => 'Admin')
u.role = "administrator"
u.organization = org
u.save

