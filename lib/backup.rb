require 'ostruct'
require 'logger'
require 'yaml'
require 'pathname'

module Backup
	
	DATABASE_CONFIG	= YAML.load_file(File.join(File.dirname(__FILE__), "../config/database.yml"))
	SETTINGS	= YAML.load_file(File.join(File.dirname(__FILE__), "../config/backup_manager.yml"))
	SCHEMAS		= SETTINGS.keys
	
	LOG 					= Logger.new(File.join(File.expand_path(File.dirname(__FILE__)), "../log/backup.log"), 10, 256000)
	LOG.level 		= Logger::INFO
	
	def s3_settings
		DATABASE_CONFIG['amazon_s3']
	end
	
	def settings(schema)
		SETTINGS[schema]
	end
	
	def hourly_snapshot_interval(schema)
		# returns how many hours between each 'hourly' backup (needed for daemon)
		settings = settings(schema)
		snapshots = settings['hourly'].to_f
		(24.0 / snapshots).to_i
	end
	
end

require File.expand_path(File.join(File.dirname(__FILE__), "full_backup.rb"))
require File.expand_path(File.join(File.dirname(__FILE__), "snapshot.rb"))