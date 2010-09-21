require 'rest_client'
require 'json'

class Project
  include DataMapper::Resource
  
  attr_reader :gh_data, :commits
  
  property :id,      Serial
  property :title,   String
  property :summary, String
  property :gh_repo, String
  
  belongs_to :category
  
  def init
    @gh_data = gh_repo_data() unless @gh_data
    @commits = gh_commit_data() unless @commits
  end
  
  def link
    "\#"
  end
  
  def gh_desc
    @gh_data['repository']['description']
  end
  
  def gh_homepage
    @gh_data['repository']['homepage']
  end
  
  def commits_by_month month, year
    monthly_commits = commits.dup
    monthly_commits.delete_if { |x| x.month != month || x.year != year }
  end
  
  private
    def gh_repo_data
      path = gh_repo.gsub("http://github.com/", "")
      result = RestClient.get("http://github.com/api/v2/json/repos/show/#{path}")
      JSON.parse(result.body)
    end
    
    def gh_commit_data month=nil
      commits = []
      path = gh_repo.gsub("http://github.com/", "")
      result = RestClient.get("http://github.com/api/v2/json/commits/list/#{path}/master")
      data = JSON.parse(result.body)
      data['commits'].each do |commit|
        commits << Commit.new(commit['committed_date'], commit['message'])
      end
      commits
    end
end

class Commit
  attr_accessor :month, :year, :message
  
  def initialize date, message
    rdate = Date.parse(date)
    @month = rdate.month
    @year = rdate.year
    @message = message
  end
end