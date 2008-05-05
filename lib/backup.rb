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
	
end

require File.expand_path(File.join(File.dirname(__FILE__), "full_backup.rb"))
require File.expand_path(File.join(File.dirname(__FILE__), "snapshot.rb"))