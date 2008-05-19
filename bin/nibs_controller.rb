# Nemo Backup Controller
# Starts a Scheduler thread that forks into the background and runs Snapshots & Backups at intervals specified in 

require 'optparse'
require 'openwfe/util/scheduler'
require File.expand_path(File.join(File.dirname(__FILE__), "../lib/backup.rb"))

include Backup
include OpenWFE


begin
	scheduler = Scheduler.new
	scheduler.start

	SCHEMAS.each do |schema|
		settings = settings(schema)
		interval = hourly_snapshot_interval(schema)
	
		unless settings['source'].nil?
		
			unless settings['hourly'].nil? || settings['snapdir'].nil?
				scheduler.schedule_every("#{interval}h", :tags => ['snapshot', 'hourly', schema]) do
					snapshot = Snapshot.new(schema, "hourly")
					snapshot.snap
				end
			end	
			unless settings['daily'].nil? || settings['snapdir'].nil?
				scheduler.schedule_every("24h", :tags => ['snapshot', 'daily', schema]) do
					snapshot = Snapshot.new(schema, "daily")
					snapshot.snap
				end
			end
		
		end
	end
rescue
	puts "Error"
end