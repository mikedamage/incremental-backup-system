require 'rubygems'
require 'zip/zipfilesystem'
require 'fileutils'
require 'pathname'

class FullBackup < Backup
	# Represents a full backup of one of the schemata in the Settings file.
	attr_reader :schema, :src, :dest, :src_size, :dest_free_space
	
	def initialize(schema)
		@schema 					= Backup::SETTINGS[schema]
		@src							= Pathname.new(@schema['source'])
		@dest							= Pathname.new(@schema['backup directory'])
	end
	
	def get_source_size
		LOG.info("Calculating size of the files to be backed up. This may take a while...")
		output 		= `time du -ckd 0 #{@src.to_s}`
		@src_size	= output.slice(/^\d+/).to_i
		LOG.info("Total Size: #{@src_size.to_s} Megabytes")
	end
	
	def get_dest_free_space
		
	end
	
	def copy_files
		FileUtils.mkdir_p "#{@dest}/FullBackup_#{Time.now.strftime("%d-%m-%Y")}"
		FileUtils.cp_r "#{@src.to_s}/.", @dest.to_s
		
	end
	
	def compress
		system "zip"
	end
	
end