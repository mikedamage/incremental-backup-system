#!/usr/bin/env ruby
#
# = Nemo Backup Controller
#
# == Summary
# Starts a Scheduler thread that forks into the background and runs Snapshots 
# & Backups from the profiles in config/backup_manager.yml

require 'rubygems'
require 'daemons'
require 'openwfe/util/scheduler'
require File.join(File.dirname(File.expand_path(__FILE__)), "../lib/backup.rb")

include Backup
include OpenWFE

APP_DIR = File.join(File.dirname(File.expand_path(__FILE__)), "..")

Daemons.run_proc(
	'nibs_scheduler',
	:dir_mode => :normal,
	:dir => File.join(APP_DIR, "log"),
	:multiple => false,
	:backtrace => true,
	:monitor => true,
	:log_output => true) do

	scheduler = Scheduler.new
	scheduler.start
	SCHEMAS.each do |schema|
		settings = settings(schema)
		interval = hourly_snapshot_interval(schema)
		unless settings['source'].nil?
			unless settings['hourly'].nil? || settings['snapdir'].nil?
				puts schema
				scheduler.schedule_every("#{interval}h", :tags => ['snapshot', 'hourly', schema]) do
					snapshot = Snapshot.new(schema, "hourly")
					snapshot.snap
				end
			end	
			unless settings['daily'].nil? || settings['backupdir'].nil?
				scheduler.schedule_every("24h", :tags => ['snapshot', 'daily', schema]) do
					snapshot = Snapshot.new(schema, "daily")
					snapshot.snap
				end
			end
		end
	end
	# Aligns this script's thread with that of the scheduler (script runs until the scheduler is stopped).
	scheduler.join 


	# Make sure we shut down politely:
	#Signal.trap("TERM") do
	at_exit do
		scheduler.stop
		puts "Scheduler Stopped."
	end
end