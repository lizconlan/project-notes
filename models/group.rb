require 'rest_client'
require 'json'

class Group
  include DataMapper::Resource
  
  property :id,      Serial
  property :title,   String
  property :summary, String
  
  belongs_to :category
  has n, :projects, :through => Resource
end