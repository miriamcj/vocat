namespace :development do
  desc "Truncate all tables"
  task :truncate => :environment do
    generator = Utility::SampleDataGenerator.new
    generator.truncate
  end

  desc "Reload all demo data"
  task :load => :environment do
    Rake::Task['development:truncate'].invoke
    Rake::Task['db:seed'].invoke
    Rake::Task['development:sample'].invoke
  end

  desc "Adds dummy data to the database"
  task :sample => :environment do
    generator = Utility::SampleDataGenerator.new
    generator.fill
  end

  desc "removes all data from the database"
  task :purge => :environment do
    generator = Utility::SampleDataGenerator.new
    generator.empty
  end

end