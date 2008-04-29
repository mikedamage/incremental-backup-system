require 'fileutils'
require 'pathname'

class Snapshot < Backup
	attr_reader :src, :dest, :schema, :siblings, :oldest_sib, :excludes
	
	# Initialize with only one schema, control taking snapshots of *each* schema in the settings file
	# from the command line script or the superclass.
	def initialize(schema)
		@schema 		= Backup::SETTINGS[schema]
		@src 				= Pathname.new(@schema['source'])
		@dest 			= Pathname.new(@schema['snapshot directory'])
		@max_snaps	= @schema['snapshots']
		@excludes		= @schema['exclude'].map {|e| "--exclude=#{e} " }
		@siblings 	= @dest.children.reverse
		@oldest_sib = @siblings[0].to_s
		
		@dest.mkpath unless @dest.exist?
	end

	def snap
		age_siblings unless @siblings.empty?
		(@dest + "Snapshot.0").mkpath if @siblings.empty?
		
		self.synchronize_snap_zero
	end

	def age_siblings
		@siblings.each do |sib|
			d = sib.to_s
			rev = d.slice(/\d+/).to_i

			if rev >= @max_snaps
				# Delete snapshots past max number to keep...
				LOG.info("Deleting old snapshots...")
				Pathname.rmtree(d)
				LOG.info("..done")
			elsif rev > 0
				# Rename the snapshots from 1 to Max, increasing by 1
				oldname = d
				newname = @dest.to_s + "/Snapshot." + (rev + 1).to_s
				FileUtils.mv(oldname, newname)
				LOG.info("Aging #{oldname}...")
			else
				# Treat Snapshot 0 differently, creating a hardlink-only copy of itself to Snapshot.1		
				`cd #{(@dest + "Snapshot.0").to_s} && find . -print | cpio -dplm #{(@dest + "Snapshot.1").to_s} ;`
				LOG.info("Created a hard-link copy of Snapshot.0")
			end
		end
	end
	
	# TODO: To make sure it lists all of the patterns to exclude correctly, use Array#map instead of just puts!
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