require 'ostruct'
require 'logger'
require 'yaml'
require 'pathname'

class Backup

	SETTINGS	= YAML.load_file(File.join(File.dirname(__FILE__), "../config/settings.yml"))
	SCHEMAS		= []
	
	SETTINGS.each_key { |k| SCHEMAS << k }
	
	LOG 					= Logger.new(File.join(File.expand_path(File.dirname(__FILE__)), "../log/backup.log"), 10, 256000)
	LOG.level 		= Logger::INFO
	
end

require File.expand_path(File.join(File.dirname(__FILE__), "full_backup.rb"))
require File.expand_path(File.join(File.dirname(__FILE__), "snapshot.rb"))