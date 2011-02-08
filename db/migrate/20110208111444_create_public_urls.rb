class CreatePublicUrls < ActiveRecord::Migration
  def self.up
    create_table :public_urls do |t|
      t.string :link_text
      t.string :link
      t.integer :project_id
    end
  end
  
  def self.down
    drop_table :public_urls
  end
end