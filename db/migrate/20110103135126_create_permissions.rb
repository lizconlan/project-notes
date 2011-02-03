class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :user_id
      t.integer :project_id
      t.boolean :edit
      t.boolean :owner
    end
  end

  def self.down
    drop_table :permissions
  end
end