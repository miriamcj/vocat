# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# guard :copy, :from => 'app/assets/javascripts', :mkpath => true, :verbose => true, :to => 'build/javascripts/src' do
#    watch(%r{^.+\.(js|hbs)$})
# end

coffeescript_options = {
  input: 'app/assets/javascripts',
  output: 'build/javascripts/src',
  patterns: [%r{^app/assets/javascripts/(.+\.(?:coffee|coffee\.md|litcoffee))$}],
  all_on_start: true
}

guard 'coffeescript', coffeescript_options do
  coffeescript_options[:patterns].each { |pattern| watch(pattern) }
end
