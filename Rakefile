require 'rubygems'
require 'fastercsv'
require 'dm-core'
require 'dm-migrations'

require 'spec/rake/spectask'
require 'models/category'
require 'models/project'

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
  Category.auto_migrate!
end

desc "Load data"
task :load_data do
  #load data from projects.csv into local data store
  data = File.new("data/projects.csv").readlines
  data.each do |line|
    line_data = FasterCSV::parse_line(line)
    
    name = line_data[0].strip
    repo = line_data[1].strip
    desc = line_data[2].strip
    cat  = line_data[3].strip
    
    #find or create the Category
    category = Category.first_or_create(:name => cat)
    
    #don't bother creating something that's already there
    unless Project.first(:title => name)
      project = Project.create(:title => name, :gh_repo => repo, :summary => desc, :category => category)
      project.save
    end
  end
end