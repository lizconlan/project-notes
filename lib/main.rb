require 'rubygems'
require 'sinatra'
require 'dm-core'

path_to_db = File.expand_path(File.dirname(__FILE__) + "/data")
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{path_to_db}/projects.db")

get '/' do
  "hello"
end

get "/favicon.ico" do
  ""
end