require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'haml'
require 'sass'

require 'models/category'
require 'models/project'

path_to_db = File.expand_path(File.dirname(__FILE__) + "/../db")
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{path_to_db}/projects.db")

get "/favicon.ico" do
  ""
end

get "/styles.css" do
  sass :styles
end

get '/' do
  @categories = Category.all
  haml :index
end

get '/:id' do
  id = params[:id]
  
  @categories = Category.all
  @project = Project.get(id)
  haml :project
end