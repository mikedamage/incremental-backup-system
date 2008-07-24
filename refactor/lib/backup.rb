require 'ostruct'
require 'logger'
require 'yaml'
require 'pathname'
require 'rubygems'

class Backup
	@@settings = YAML.load_file(File.join(File.dirname(__FILE__), "../config/settings.yml"))
	@@profiles = @@settings['BackupProfiles']
	
	attr_reader :profile
	
	def initiailze(profile)
		@profile 	= profile
		@settings = @@profiles[@profile]
		@source		= Pathname.new(@settings['Source'])
	end
	
	
end