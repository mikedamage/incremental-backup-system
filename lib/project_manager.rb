require 'rubygems'
require 'activerecord'
require 'yaml'
require 'find'

module ProjectManager
	
	SETTINGS				= YAML.load_file(File.join(File.dirname(__FILE__), "../config/settings.yml"))
	DATABASE_CONFIG	= YAML.load_file(File.join(File.dirname(__FILE__), "../config/database.yml"))
	
	ACTIVE_PROJECTS_DIR			=	SETTINGS['active']
	DORMANT_PROJECTS_DIR 		= SETTINGS['dormant']
	COMPLETED_PROJECTS_DIR 	= SETTINGS['completed']
	
	ActiveRecord::Base.establish_connection(
		:adapter	=> DATABASE_CONFIG['adapter'],
		:host			=> DATABASE_CONFIG['host'],
		:username	=> DATABASE_CONFIG['username'],
		:password	=> DATABASE_CONFIG['password'],
		:database	=> DATABASE_CONFIG['database']
	)
	
end

Dir["#{File.expand_path(File.dirname(__FILE__))}/*"].each do |file|
  require "#{file}" if file =~ /\.rb$/ && file !~ /project_manager.rb/
end