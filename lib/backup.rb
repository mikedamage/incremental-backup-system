require 'ostruct'
require 'logger'
require 'yaml'
require 'pathname'

module Backup

	SETTINGS	= YAML.load_file(File.join(File.dirname(__FILE__), "../config/backup_manager.yml"))
	SCHEMAS		= SETTINGS.keys
	
	LOG 					= Logger.new(File.join(File.expand_path(File.dirname(__FILE__)), "../log/backup.log"), 10, 256000)
	LOG.level 		= Logger::INFO
	
	def settings(schema)
		SETTINGS[schema]
	end
	
	def hourly_snapshot_interval(schema)
		# returns how many hours between each 'hourly' backup (needed for daemon)
		schema = settings(schema)
		snapshots = schema['hourly'].to_f
		interval = (24.0 / snapshots).to_i
	end
	
	def backup_times(schema)
		start_time = Time.now
		backup_times = []
		# This method returns the times at which snapshots will be taken, based on how many snapshots are supposed to be taken per day. They will occur at evenly spaced intervals.
	end
	
end

require File.expand_path(File.join(File.dirname(__FILE__), "full_backup.rb"))
require File.expand_path(File.join(File.dirname(__FILE__), "snapshot.rb"))