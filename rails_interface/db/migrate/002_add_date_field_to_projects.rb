class AddDateFieldToProjects < ActiveRecord::Migration
  def self.up
		add_column :projects, :date_started, :date, { :default => Time.now.strftime("%Y-%m-%d") }
  end

  def self.down
		remove_column :projects, :date_started
  end
end
