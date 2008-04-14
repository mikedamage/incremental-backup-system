require 'ostruct'
require 'fileutils'
require 'pathname'

module Backup
	class Snapshot
		attr_accessor :src, :dest, :siblings, :oldest_sib

		def initialize(src, dest)
			@src = Pathname.new(src)
			@dest = Pathname.new(dest)
			@siblings = @dest.children.reverse
			@oldest_sib = @siblings[0].to_s
		end

		def snap
			# Creates a new incremental snapshot backup of *source* directory, storing it in a numbered subdirectory of *destination*
			age_siblings unless @siblings.empty?
		end

		def age_siblings
			@siblings.each do |sib|
				d = sib.to_s
				rev = d.slice(/\d+/).to_i

				if rev >= $prefs.max_snaps
					# Delete snapshots past max number to keep...
					Pathname.rmtree(d)
				elsif rev > 0
					# Rename the snapshots from 1 to Max, increasing by 1
					oldname = d
					newname = @dest.to_s + "/Snapshot." + (rev + 1).to_s
					FileUtils.mv(oldname, newname)
				else
					# Treat Snapshot 0 differently, creating a hardlink-only copy of itself to Snapshot.1		
					system "cd #{(@dest + "Snapshot.0").to_s} && find . -print | cpio -dplm #{(@dest + "Snapshot.1").to_s} ;"
				end
			end
		end
	end
end