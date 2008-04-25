class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :path
      t.string :status
      t.string :project_id
      t.text :comments
      t.text :access_info

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
