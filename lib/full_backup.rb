require 'zip/zip'
require 'zip/zipfilesystem'
require 'fileutils'
require 'pathname'
require 'find'

class FullBackup
	include Backup
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
	
	def compress
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
		Dir.glob("#{@dest}/*.0").each {|f| File.delete(f) }	# Get rid of temporary files created by rubyzip.
	end
	
end