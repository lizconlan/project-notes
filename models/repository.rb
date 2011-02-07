require 'rest-client'
require 'json'

class Repository < ActiveRecord::Base
  belongs_to :project
  
  def description
    path = github_url.gsub("http://github.com/", "")
    result = RestClient.get("http://github.com/api/v2/json/repos/show/#{path}")
    gh_data = JSON.parse(result.body)
    gh_data['repository']['description']
  end
end