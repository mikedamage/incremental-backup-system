require 'yaml'
require 'find'

module ProjectManager
	
	GLOBAL_SETTINGS	= YAML.load_file(File.join(File.dirname(__FILE__), "../config/settings.yml"))
	DATABASE_CONFIG	= YAML.load_file(File.join(File.dirname(__FILE__), "../config/database.yml"))
	
	ACTIVE_PROJECTS_DIR			=	GLOBAL_SETTINGS["Active Projects"]
	DORMANT_PROJECTS_DIR 		= GLOBAL_SETTINGS["Dormant Projects"]
	COMPLETED_PROJECTS_DIR 	= GLOBAL_SETTINGS["Completed Projects"]
	
end

Dir["#{File.expand_path(File.dirname(__FILE__))}/*"].each do |file|
  require "#{file}" if file =~ /\.rb$/ && file !~ /project_manager.rb/
end