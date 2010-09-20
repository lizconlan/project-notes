require 'rubygems'
require 'sinatra'
require 'datamapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://projects.db')

get '/' do
  "hello"
end

get "/favicon.ico" do
  ""
end