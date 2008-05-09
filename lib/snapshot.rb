require 'fileutils'
require 'pathname'
require 'find'

class Snapshot
	include Backup
	attr_reader :src, :dest, :schema, :siblings, :oldest_sib, :latest, :excludes, :interval
	
	# Instance Methods
	def initialize(schema, interval)
		@schema 		= settings(schema)
		@interval		= interval
		begin
			FileUtils.mkpath("#{@schema['snapshot directory']}/#{interval}") unless FileTest.exist?("#{@schema['snapshot directory']}/#{interval}")
			@src 				= Pathname.new(@schema['source'])
			@dest 			= Pathname.new(@schema['snapshot directory'] + "/#{interval}")
			@max_snaps	= @schema[interval]
			@excludes		= @schema['exclude'].map {|e| "--exclude=#{e} " }
			@siblings 	= @dest.children.reverse.delete_if {|x| x.basename.to_s !~ /Snapshot\.\d+/ }
			@oldest_sib = @siblings[0].to_s
			@latest			= @dest + "Snapshot.0"
		rescue Errno::ENOENT => e
			puts "Couldn't find your source or could not create the destination... Check your settings file.\n" + e
			LOG.error(e)
			exit
		end
	end

	def snap
		unless @siblings.empty?
			age_siblings if File.basename(@oldest_sib).slice(/\d+$/).to_i > 0
			copy_hardlinks("#{(@dest + "Snapshot.0").to_s}", "#{(@dest + "Snapshot.1").to_s}")
		end
		synchronize_snap_zero
		refresh
		return true
	end
	
	private
		def age_siblings
			@siblings.each do |sib|
				d = sib.to_s
				rev = d.slice(/\d+$/).to_i
				if rev >= @max_snaps
					# Delete snapshots past max number to keep...
					LOG.info("Deleting #{sib.basename}")
					Pathname.new(d).rmtree
				elsif rev > 0
					# Rename the snapshots from 1 to Max, increasing by 1
					oldname = d
					newname = (@dest + "Snapshot.#{(rev + 1).to_s}").to_s
					FileUtils.mv(oldname, newname)
					LOG.info("Aging #{sib.basename} => #{File.basename(newname)}")
				end
			end
		end

		def refresh
			@dest 			= Pathname.new(@schema['snapshot directory'] + "/#{interval}")
			@siblings 	= @dest.children.reverse.delete_if {|x| x.basename.to_s !~ /Snapshot\.\d+/ }
			@oldest_sib = @siblings[0].to_s
			self
		end
	
		def copy_hardlinks(source, destination)
			Dir.chdir(source)
			Find.find(".") do |f|
				file = f
				file[0..1] = ""
				if FileTest.directory?(File.expand_path(file))
					FileUtils.mkpath(File.join(destination, file))
				else
					File.link(file, File.join(destination, file))
				end
			end
		end
		
		# TODO: Figure out how to interact with rsync's C library
		# TODO: Consider using a pure Ruby sync method, just comparing the modification times and changes in file size?
		def synchronize_snap_zero
			LOG.info("Synchronizing #{@src.to_s} with #{(@dest + "Snapshot.0").to_s}")
			`rsync -avzrE --delete #{@excludes.to_s}#{@src.to_s}/ #{(@dest + "Snapshot.0").to_s}/`
			LOG.info("...done")
		end
	
		def synchronize_snap_zero_no_delete
			LOG.info("Synchronizing #{@src.to_s} with #{(@dest + "Snapshot.0").to_s}")
			`rsync -avzrE #{@excludes.to_s}#{@src.to_s}/ #{(@dest + "Snapshot.0").to_s}/`
			LOG.info("...done")
		end
	
end