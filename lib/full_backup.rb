require 'zip/zip'
require 'zip/zipfilesystem'
require 'fileutils'
require 'pathname'
require 'find'

class FullBackup < Backup
	# Represents a full backup of one of the schemata in the Settings file.
	include Zip
	attr_reader :schema, :src, :dest, :date, :src_size, :dest_free_space
	
	def initialize(schema)
		@date		= Time.now.strftime("%m-%d-%Y")
		@schema	= Backup::SETTINGS[schema]
		@src		= Pathname.new(@schema['source'])
		@dest		= Pathname.new(@schema['backup directory'])
		
		@dest.mkpath unless @dest.exist?
	end
	
	def get_source_size
		LOG.info("Calculating size of the files to be backed up. This may take a while...")
		output 		= `du -ckd 0 #{@src.to_s}`
		@src_size	= output.slice(/^\d+/).to_i
		LOG.info("Total Size: #{@src_size.to_s} Megabytes")
	end
	
	def get_dest_free_space
		output = `df -m #{@dest.to_s} | awk '{print $4}'`
		@dest_free_space	= output.slice(/\d+$/).to_i
		LOG.info("Destination volume has #{@dest_free_space.to_s} MB of free space")
	end
	
	def copy_files
		LOG.info("Copying files to temporary directory...")
		FileUtils.mkdir_p "#{@dest.to_s}/FullBackup_#{@date}"
		FileUtils.cp_r "#{@src.to_s}/.", @dest.to_s
		LOG.info("...done")
	end
	
	def compress
		# TODO: Rewrite this method using RubyZip to compress files on the fly and eliminate need for temporary files
		# 		system "zip #{@dest.to_s}/FullBackup_#{@date}.zip #{@dest.to_s}/FullBackup_#{@date}/"
		# 		LOG.info("Backup successfully compressed! Removing temporary directory...")
		# 		FileUtils.rm_r "#{@dest.to_s}/FullBackup_#{@date}"
		
		Dir.chdir(@src.dirname)
		Zip::ZipFile.open((@dest + "FullBackup_#{@date}.zip").to_s, Zip::ZipFile::CREATE) do |zipfile|
			Find.find(@src.basename.to_s) do |file|
				if FileTest.directory?(file)
					zipfile.dir.mkdir(file)
				else
					zipfile.file.open(file, "w") {|f| f.write IO.read(file) }
				end
			end
		end
		Dir.glob("#{@dest}/*.0").each {|f| File.delete(f) }	
	end
	
end