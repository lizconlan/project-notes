class User < ActiveRecord::Base
  has_many :permissions
  has_many :projects, :through => :permissions
  
  acts_as_authentic
end