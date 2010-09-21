require 'rubygems'
require 'sinatra'
require 'dm-core'

require 'models/category'
require 'models/project'

path_to_db = File.expand_path(File.dirname(__FILE__) + "/../db")
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{path_to_db}/projects.db")

get '/' do
  html = ""  
  Category.each do |cat|
    html += "<h2>#{cat.name}</h2>\n"
    cat.projects.each do |project|
      html += "<a href=\"#{project.link}\">#{project.title}</a><br />\n"
    end
    html += "\n"
  end
  html
end

get '/:title' do
  title = params[:title]
end

get "/favicon.ico" do
  ""
end