module Backup
	class Snapshot
		attr_reader :profile, :interval
	
		def initialize(profile)
			@profile			= PROFILES[profile]
			@snap_prefs		= @profile['snapshots']
			@interval 		= @snap_prefs['interval']
			@destination	= Pathname.new(@snap_prefs['storage'])
			@snapshots		= @destination.children.sort {|x,y| x.ctime <=> y.ctime }
			@latest_snap	= @snapshots.last
		end
	
	end
end