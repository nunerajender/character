# encoding: UTF-8
namespace :character do
  
  desc 'Add admin user: rake character::add_admin[admin@email.com]'
  task :add_admin, [:email] => :environment do |task, args|
    # TODO: add user name to this task
    #       revise this method after Devise is integrated
    email = args.email
    Character::AdminUser.create! email: email
    puts "Admin user with #{ email } is added."
  end
  
end