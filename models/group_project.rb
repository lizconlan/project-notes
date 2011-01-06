require 'rest_client'
require 'json'

class GroupProject
  include DataMapper::Resource
  
  property :id,      Serial
  
  belongs_to :project
  belongs_to :group
end