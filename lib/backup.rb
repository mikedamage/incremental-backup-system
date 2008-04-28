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

Pathname.new(__FILE__).dirname.children.each do |file|
	require "#{file.to_s}" if file.to_s =~ /\.rb$/ && file.to_s != /backup.rb/
end
