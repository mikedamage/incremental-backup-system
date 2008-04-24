require 'ostruct'
require 'logger'
require 'yaml'

class Backup

	SETTINGS			= YAML.load_file(File.join(File.dirname(__FILE__), "../config/settings.yml"))
	SCHEMAS				= []
	SETTINGS.each_key { |k| SCHEMAS << k }
	
	LOG 					= Logger.new(File.join(File.expand_path(File.dirname(__FILE__)), "../log/backup.log"), 10, 256000)
	LOG.level 		= Logger::INFO
	
end

Dir["#{File.expand_path(File.dirname(__FILE__))}/*"].each do |file|
  require "#{file}" if file =~ /\.rb$/ && file !~ /backup.rb/
end
