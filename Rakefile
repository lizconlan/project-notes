require 'rubygems'
require 'fastercsv'

require 'spec/rake/spectask'
require 'models/category'
require 'models/project'

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--colour', '--format=progress']
end

desc "Run RCov on /lib"
Spec::Rake::SpecTask.new('rcov_lib') do |t|
  t.rcov = true
  t.rcov_opts = ['--exclude', '/Library/Ruby/Gems/1.8/,spec']
end

desc "Load data"
task :load_data do
  #load data from projects.csv into local data store
end
end