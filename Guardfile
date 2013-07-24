# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'coffeescript', :input => 'app/assets/javascripts', :output => 'build/javascripts/src'
guard :copy, :from => 'app/assets/javascripts', :mkpath => true, :verbose => true, :to => 'build/javascripts/src' do
   watch(%r{^.+\.(js|hbs)$})
end
