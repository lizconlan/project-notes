require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'haml'
require 'sass'

require 'models/category'
require 'models/project'
require 'models/group'

path_to_db = File.expand_path(File.dirname(__FILE__) + "/db")
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{path_to_db}/projects.db")

get "/favicon.ico" do
  status 404
end

get "/styles.css" do
  sass :styles
end

get '/' do
  @categories = Category.all
  haml :index
end

get '/:category/?' do
  category = params[:category]
  
  @category = Category.first(:slug => category)
  haml :category
end

get '/:category/:title/?' do
  category = params[:category]
  @category = Category.first(:slug => category)
  
  title = params[:title]
  @group = Group.first(:slug => title)
  if @group
    haml :group
  else
    @project = Project.first(:slug => title)
    @project.init()
    haml :project
  end
end

get '/:category/:group/:title/?' do
  category = params[:category]
  @category = Category.first(:slug => category)
  @group = Group.first(:slug => params[:group])
  
  title = params[:title]
  @project = Project.first(:slug => title)
  @project.init()
  haml :project
end