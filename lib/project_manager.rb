require 'rubygems'
require 'activerecord'
require 'yaml'
require 'find'
require 'fileutils'

module ProjectManager
	
	SETTINGS				= YAML.load_file(File.join(File.dirname(__FILE__), "../config/project_manager.yml"))
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

require File.expand_path(File.join(File.dirname(__FILE__), 'project.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'archive.rb'))