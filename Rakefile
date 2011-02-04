require 'rubygems'
require 'bundler'

Bundler.setup

require 'active_record'
require 'authlogic'
require 'models/user'

namespace :db do  
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end
end

task :environment do
  env = ENV["RACK_ENV"] ? ENV["RACK_ENV"] : "development"
  ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml'))[env])
end

desc "Create initial admin user"
  task :create_admin_user => :environment do
    password = ENV['password']
    unless password
      puts 'must supply password for the new admin user'
      puts 'USAGE: rake create_admin_user password=pass'
    else
      modules_to_load = [
        Authlogic::ActsAsAuthentic::SingleAccessToken::Methods::InstanceMethods,
        Authlogic::ActsAsAuthentic::SingleAccessToken::Methods,
        Authlogic::ActsAsAuthentic::SessionMaintenance::Methods,
        Authlogic::ActsAsAuthentic::PersistenceToken::Methods::InstanceMethods,
        Authlogic::ActsAsAuthentic::PersistenceToken::Methods,
        Authlogic::ActsAsAuthentic::PerishableToken::Methods::InstanceMethods,
        Authlogic::ActsAsAuthentic::PerishableToken::Methods,
        Authlogic::ActsAsAuthentic::Password::Methods::InstanceMethods,
        Authlogic::ActsAsAuthentic::Password::Methods,
        Authlogic::ActsAsAuthentic::Password::Callbacks,
        Authlogic::ActsAsAuthentic::MagicColumns::Methods,
        Authlogic::ActsAsAuthentic::Login::Methods,
        Authlogic::ActsAsAuthentic::LoggedInStatus::Methods::InstanceMethods,
        Authlogic::ActsAsAuthentic::LoggedInStatus::Methods,
        Authlogic::ActsAsAuthentic::Email::Methods
      ].reject{ |m| User.included_modules.include? m }
      User.send :include, *modules_to_load
      User.create_admin_user(password)
    end
  end