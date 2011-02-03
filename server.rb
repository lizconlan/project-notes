require 'haml'
require 'sass'

env = ENV["RACK_ENV"] ? ENV["RACK_ENV"] : "development"
ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml'))[env])

get "/favicon.ico" do
  status 404
end

get "/styles.css" do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles
end

get "/" do
  "hello"
end

get "/login/?" do
end

get "/logout/?" do
end

get "/account/create/?" do
end

get "/account/:name/?" do
end

get "/account/:name/destroy/?" do
end

get "/:project/?" do
end

get "/:project/edit/?" do
end