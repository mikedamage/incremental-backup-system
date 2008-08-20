require 'ostruct'
require 'logger'
require 'yaml'
require 'pathname'
require 'rubygems'

module Backup
	SETTINGS = YAML.load_file(File.join(File.dirname(__FILE__), "../config/config.yml"))
	PROFILES = SETTINGS['backup_profiles']	
end

require File.join(File.expand_path(File.dirname(__FILE__)), 'snapshot.rb')

# Pathname.new(File.expand_path(File.dirname(__FILE__))).children.each do |file|
# 	filename = file.to_s
# 	
# 	if filename != "backup.rb" && filename =~ /\.rb$/
# 		require filename
# 	end
# 	
# end