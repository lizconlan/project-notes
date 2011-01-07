require 'rubygems'
require 'json'
require 'dm-core'
require 'dm-migrations'

require 'spec/rake/spectask'
require 'models/category'
require 'models/group_project'
require 'models/project'
require 'models/group'

path_to_db = File.expand_path(File.dirname(__FILE__) + "/db")
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{path_to_db}/projects.db")

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--colour', '--format=progress']
end

desc "Run RCov on /lib"
Spec::Rake::SpecTask.new('rcov_lib') do |t|
  t.rcov = true
  t.rcov_opts = ['--exclude', '/Library/Ruby/Gems/1.8/,spec']
end

desc "Set up db"
task :db_setup do
  DataMapper.finalize
  Project.auto_migrate!
  GroupProject.auto_migrate!
  Category.auto_migrate!
  Group.auto_migrate!
end

desc "Load data"
task :load_data do
  json = File.new("data/projects.json").read
  data = JSON.parse(json)

  data["categories"].each do |category|
    #find or create the Category
    stored_category = Category.first_or_create(:name => category["category"]["name"], :slug => category["category"]["name"].downcase.gsub("-", "--").gsub(" ", "-"))
    
    category["category"]["projects"].each do |project|
      if project["group"]
        unless Group.first(:title => project["group"]["name"])
          stored_group = Group.create(:title => project["group"]["name"], :summary => project["group"]["desc"], :category => stored_category)
          stored_group.slug = project["group"]["name"].downcase.gsub("-", "--").gsub(" ", "-")
          stored_group.save
        end
        project["group"]["projects"].each do |sub_project|
          unless Project.first(:title => sub_project["project"]["name"])
            stored_project = Project.create(:title => sub_project["project"]["name"], :gh_repo => sub_project["project"]["repo"], :category => stored_category)
            stored_project.slug = sub_project["project"]["name"].downcase.gsub("-", "--").gsub(" ", "-")
            stored_project.groups << stored_group
            stored_project.save
            
            stored_group.projects << stored_project
            stored_group.save
          end
        end
      else
        unless Project.first(:title => project["project"]["name"])
          stored_project = Project.create(:title => project["project"]["name"], :gh_repo => project["project"]["repo"], :category => stored_category)
          stored_project.slug = project["project"]["name"].downcase.gsub("-", "--").gsub(" ", "-")
          stored_project.save
        end
      end
    end
  end
end