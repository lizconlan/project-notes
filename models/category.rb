class Category
  include DataMapper::Resource
  
  property :id,      Serial
  property :name,    String
  property :slug,    String
  
  has n, :projects
  has n, :groups
end