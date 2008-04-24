class SnapshotMigration < ActiveRecord::Migration
  def self.up
    create_table :snapshots do |t|

      t.timestamps
    end 
  end

  def self.down
    drop_table :snapshots
  end
end
