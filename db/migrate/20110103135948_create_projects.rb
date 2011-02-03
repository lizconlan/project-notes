class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :status
      t.string :teaser
      t.string :category
      t.string :description
      t.integer :account_id
    end
  end
  
  def self.down
    drop_table :projects
  end
end