class CreateRepositories < ActiveRecord::Migration
  def self.up
    create_table :repositories do |t|
      t.string :name
      t.string :github_url
      t.string :notes
      t.integer :project_id
    end
  end
  
  def self.down
    drop_table :repositories
  end
end