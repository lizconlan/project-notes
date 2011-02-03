require 'rubygems'
require 'bundler'

Bundle.setup

require File.dirname(__FILE__) + "/server"

disable :run, :reload
set :logging, false

run Sinatra::Application