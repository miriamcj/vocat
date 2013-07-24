require 'guard'

namespace :assets do
  desc "Builds javascript assets using r.js and kicks off sprockets asset precompilation"

  task :build => [:precompile] do

    # Get the guards
    Guard.setup
    csg = Guard.guards(:coffeescript)
    cg = Guard.guards(:copy)

    # Should be done automatically; seems like a bug with the copy guard.
    cg.targets.each do |t|
      t.resolve!
    end
    csg.run_all
    cg.run_all

    # Execute r.js compression
    Dir.chdir('build') do
      puts %x( pwd )
      puts %x( r.js -o build.js )
    end

  end

end
