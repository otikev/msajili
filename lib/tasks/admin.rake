
namespace :admin do
  desc 'Create the default admin account if it doesn\'t already exist.'
  task :create => :environment do
    admin = Administrator.where(:email => 'admin@msajili.com').first
    if !admin
      admin = Administrator.create!(
                            :email => 'admin@msajili.com',
                            :first_name => 'Msajili',
                            :last_name => 'Administrator',
                            :password => 'adminadmin')
      if admin
        puts 'admin successfully created'
      end
    else
      puts 'Admin already exists!'
    end
  end
end
