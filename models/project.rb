require 'rest_client'
require 'json'

class Project
  include DataMapper::Resource
  
  attr_reader :gh_data, :commits
  
  property :id,      Serial
  property :title,   String
  property :summary, String
  property :gh_repo, String
  property :slug,    String
  
  belongs_to :category
  has n, :groups, :through => Resource
  
  def init
    @gh_data = gh_repo_data() unless @gh_data
    @commits = gh_commit_data() unless @commits
    @gh_contribs = gh_contribs_data()
  end
  
  def gh_desc
    @gh_data['repository']['description']
  end
  
  def gh_homepage
    @gh_data['repository']['homepage']
  end
  
  def gh_contribs
    @gh_contribs
  end
  
  def commits_by_month_and_year month, year
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
    
    def gh_contribs_data
      path = gh_repo.gsub("http://github.com/", "")      
      
      #grab the main contributors data
      result = RestClient.get("http://github.com/api/v2/json/repos/show/#{path}/contributors")
      data = JSON.parse(result.body)
      contribs = data['contributors'].collect{ |x| {:name => x["name"], :login => x["login"]} }
      
      #grab the "anon" results
      result = RestClient.get("http://github.com/api/v2/json/repos/show/#{path}/contributors/anon")
      data = JSON.parse(result.body)
      anon = data['contributors'].collect{ |x| x["name"] }

      #remove duplicates...
      anon.delete_if { |x| contribs.collect{ |c| c[:login]}.include?(x) }
      #...and anything that doesn't look like a login name
      anon.delete_if{ |x| x != x.downcase }
      

      #if there's anything left, add the other contributors
      if anon.length > 0
        anon.each do |name|
          begin
            result = RestClient.get("http://github.com/api/v2/json/user/show/#{name}")
            data = JSON.parse(result.body)
            contribs << {:name => data["user"]["name"], :login => data["user"]["login"]}
          rescue
            #don't add the genuinely anonymous names, too weird
          end
        end
      end
      
      contribs
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