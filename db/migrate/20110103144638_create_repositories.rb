class CreateRepositories < ActiveRecord::Migration
  def self.up
    create_table :repositories do |t|
      t.string :github_url
      t.string :name
    end
  end
  
  def self.down
    drop_table :repositories
  end
end