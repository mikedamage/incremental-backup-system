require 'fileutils'
require 'find'
require 'pathname'
require 'yaml'
require 'rubygems'
require 'activerecord'

class Project < ActiveRecord::Base
	include ProjectManager
	
	def self.update_active_from_filesystem
		@active_projects = Dir.entries(ProjectManager::ACTIVE_PROJECTS_DIR).delete_if { |x| x == "." || x == ".." }
		
		@active_projects.each do |project|	# list all the active projects
			syspath = File.expand_path(project)
			if File.directory?(syspath)
				if FileTest.exists?(File.join(syspath, "info.yml"))
					info = YAML.load_file(File.join(syspath, "info.yml"))
					
				else
					
				end
			end
		end
	end
	
end
