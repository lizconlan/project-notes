class Project
  include DataMapper::Resource
  
  property :id,      Serial
  property :title,   String
  property :summary, String
  property :gh_repo, String
  
  belongs_to :category
end