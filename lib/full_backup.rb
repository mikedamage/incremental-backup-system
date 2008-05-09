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
		@schema	= settings(schema)
		@src		= Pathname.new(@schema['source'])
		@dest		= Pathname.new(@schema['backupdir'])
		@dest.mkpath unless @dest.exist?
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
	
	def enough_room?
		@src_size = get_source_size
		@dest_free_space = get_dest_free_space
		@dest_free_space > @src_size
	end
	
	private
		def get_source_size
			output 		= `du -md 0 #{@src.to_s}`
			output.slice(/^\d+/).to_i
		end
	
		def get_dest_free_space
			output = `df -m #{@dest.to_s} | awk '{print $4}'`
			output.slice(/\d+$/).to_i
		end
end