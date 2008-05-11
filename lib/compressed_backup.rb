require 'rubygems'
require 'zip/zipfilesystem'
require File.expand_path(File.join(File.dirname(__FILE__), "backup.rb"))

class CompressedBackup < FullBackup
	include Zip
	attr_accessor :file
	
	def initialize(schema, file)
		super(schema)
		@file = file
	end
	
	def list_contents
		ZipFile.open(@file) do |zipfile|
			
		end
	end
	
end