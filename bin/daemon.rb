# Nemo Backup Daemon
# Loaded by backup_controller.rb and runs in the background

require 'openwfe/util/scheduler'
require File.expand_path(File.join(File.dirname(__FILE__), "../lib/backup.rb"))

include Backup
include OpenWFE

scheduler = Scheduler.new
scheduler.start

SCHEMAS.each do |schema|
	settings = settings(schema)
	interval = hourly_snapshot_interval(schema)

	scheduler.schedule_every("#{interval}h") do
		
	end	
end