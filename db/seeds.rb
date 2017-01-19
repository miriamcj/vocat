count = Doorkeeper::Application.where(:name => "Vocat").count
if count == 0
  puts "Create oAuth Application for Vocat"
  application = Doorkeeper::Application.new :name => "Vocat", :redirect_uri => "http://vocat.io"
  application.save
else
  puts "Found Vocat oAuth Application"
end
