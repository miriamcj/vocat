namespace :user do
  desc "Create Superadmin User"
  task :superadmin, [:email, :password, :first_name, :last_name] => :environment do |t, args|
    puts args

  end
end