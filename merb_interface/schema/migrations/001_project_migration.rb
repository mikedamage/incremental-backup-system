class ProjectMigration < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
			t.integer :project_id
			t.string	:name, :client, :status, :path
			t.text		:comments		
      t.timestamps
    end 
  end

  def self.down
    drop_table :projects
  end
end
