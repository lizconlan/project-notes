class ChangeGithubUrlToUrl < ActiveRecord::Migration
  def self.up
    rename_column :repositories, :github_url, :url
  end
  
  def self.down
    rename_column :repositories, :url, :github_url
  end
end