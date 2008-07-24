class Snapshot < Backup
	attr_reader :profile, :interval
	
	def initialize(profile, interval)
		super(profile)
		@interval 		= interval
		@destination	= Pathname.new(@settings['SnapshotDir'] + "/#{@interval}")
	end
	
end