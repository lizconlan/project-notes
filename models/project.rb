require 'rdiscount'

class Project < ActiveRecord::Base
  has_many :permissions
  has_many :users, :through => :permissions
  has_many :repositories
  
  def self.slug_to_name(slug)
    slug.gsub("--", "^").gsub("-", " ").gsub("^","-")
  end
  
  def slug
    name.downcase.gsub("-", "--").gsub(" ", "-")
  end
  
  def html_description
    return "" if description.nil?
    markdown = RDiscount.new(description)
    markdown.to_html
  end
end