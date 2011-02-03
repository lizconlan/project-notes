require 'rubygems'
require 'active_record'

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