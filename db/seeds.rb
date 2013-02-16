# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

for name in %w(alex gabe lucas peter scott zach)
  User.create(:email => "#{name}@castironcoding.com", :password => "chu88yhands")
end

lorem = "Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Maecenas sed diam eget risus varius blandit sit amet non magna. Aenean lacinia bibendum nulla sed consectetur."
def random_section
  rand(36**5).to_s(36).upcase
end

baruch = Organization.create(:name => "Baruch College")
baruch.courses.create(:name => "Data Structures", :department => "CS", :number => "163", :section => random_section, :description => lorem)
baruch.courses.create(:name => "Programming Systems", :department => "CS", :number => "201", :section => random_section, :description => lorem)
baruch.courses.create(:name => "Systems Programming", :department => "CS", :number => "202", :section => random_section, :description => lorem)
baruch.courses.create(:name => "Discrete Structures I", :department => "CS", :number => "250", :section => random_section, :description => lorem)
baruch.courses.create(:name => "Discrete Structures II", :department => "CS", :number => "251", :section => random_section, :description => lorem)
baruch.courses.create(:name => "AI: Combinatorial Search", :department => "CS", :number => "443", :section => random_section, :description => lorem)
baruch.courses.create(:name => "Shakespeare", :department => "ENG", :number => "201", :section => random_section, :description => lorem)
baruch.courses.create(:name => "Survey of English Literature I", :department => "ENG", :number => "204", :section => random_section, :description => lorem)
baruch.courses.create(:name => "Survey of English Literature II", :department => "ENG", :number => "205", :section => random_section, :description => lorem)
baruch.courses.create(:name => "Introduction to Literature", :department => "ENG", :number => "100", :section => random_section, :description => lorem)
baruch.courses.create(:name => "Introduction to World Literature", :department => "ENG", :number => "108", :section => random_section, :description => lorem)
baruch.courses.create(:name => "Native American Women Writers", :department => "ENG", :number => "367U", :section => random_section, :description => lorem)
baruch.courses.create(:name => "Practical Grammar", :department => "ENG", :number => "425", :section => random_section, :description => lorem)

Organization.create(:name => "Some Other College")