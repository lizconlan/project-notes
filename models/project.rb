require 'rdiscount'

class Project < ActiveRecord::Base
  has_many :permissions
  has_many :users, :through => :permissions
  has_many :repositories
  
  def html_description
    markdown = RDiscount.new(description)
    markdown.to_html
  end
end