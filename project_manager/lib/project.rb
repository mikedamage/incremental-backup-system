require 'rubygems'
require 'activerecord'

class Project < ActiveRecord::Base
	include ProjectManager
	
	def find_on_filesystem
		
	end
	
end
