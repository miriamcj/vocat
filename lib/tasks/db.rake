namespace :db do
  desc "Truncate all tables"
  task :truncate => :environment do
    conn = ActiveRecord::Base.connection
    postgres = "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname='public'"
    tables = conn.execute(postgres).map { |r| r['tablename'] }
    tables.delete "schema_migrations"
    tables.each { |t| conn.execute("TRUNCATE \"#{t}\"") }
  end

  desc "Truncate all tables and reseed"
  task :reseed => :environment do
    Rake::Task['db:truncate'].invoke
    Rake::Task['db:seed'].invoke

  end

end