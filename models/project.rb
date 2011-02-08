require 'rdiscount'

class Project < ActiveRecord::Base
  has_many :permissions
  has_many :users, :through => :permissions
  has_many :repositories
  has_many :public_urls
  
  def self.make_slug name
    name.downcase.gsub("-", "--").gsub(" ", "-")
  end
  
  def html_description
    return "" if description.nil?
    markdown = RDiscount.new(description)
    markdown.to_html
  end
end