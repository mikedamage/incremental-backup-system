require 'fileutils'
require 'find'
require 'pathname'
require 'yaml'
require 'rubygems'
require 'activerecord'

class Project < ActiveRecord::Base
	include ProjectManager
	
	def self.update_active_from_filesystem
		@active_path = Pathname.new(ProjectManager::ACTIVE_PROJECTS_DIR)
		
		@active_path.children.each do |project| # list all the active projects
			project.children.each do |file|				# open up project folders
				if file.to_s =~ /\.yml$/ 						# check for a YAML file in each project's root directory, parse if exists
					info = YAML.load_file(file.to_s)
					query = self.find(:all, :conditions => ["name = ?", info['name']]) # return an array with projects with matching names
					
					unless query.empty? # if the project exists already, just update the details
						
					else								# otherwise just create a new one
						
					end	
				end
			end
		end
	end
	
end
