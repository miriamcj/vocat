require 'guard'

namespace :assets do

  desc "Builds javascript assets using r.js and kicks off sprockets asset precompilation"
  task :build_js do


    FileUtils.mkdir_p 'build/javascripts/src'
    FileUtils.cp_r 'app/assets/javascripts/.', 'build/javascripts/src'

    # Get the guards
    Guard.setup
    csg = Guard.plugin(:coffeescript)
    # cg = Guard.plugin(:copy)

    # Should be done automatically; seems like a bug with the copy guard.
    # cg.targets.each do |t|
    #   t.resolve!
    # end

    csg.run_all
    # cg.run_all

    # Execute r.js compression
    puts %x( r.js -o build/build.js )

  end
end
