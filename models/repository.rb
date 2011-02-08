require 'rest-client'
require 'json'

class Repository < ActiveRecord::Base
  belongs_to :project
  
  def is_github?
    !(url =~ /^http:\/\/github.com/).nil?
  end
  
  def description
    if is_github?
      path = url.gsub("http://github.com/", "")
      result = RestClient.get("http://github.com/api/v2/json/repos/show/#{path}")
      gh_data = JSON.parse(result.body)
      desc = gh_data['repository']['description']
    else
      desc = ""
    end
    desc
  end
end