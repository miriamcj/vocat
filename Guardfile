# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'coffeescript', :input => 'app/assets/javascripts', :output => 'public/build/javascripts/src'
guard :copy, :from => 'app/assets/javascripts', :mkpath => true, :verbose => true, :to => 'public/build/javascripts/src' do
   watch(%r{^.+\.(js|hbs)$})
end
