#!/usr/bin/env ruby
#
# = Nemo Backup Controller
#
# == Summary
# Starts a Scheduler thread that forks into the background and runs Snapshots 
# & Backups from the profiles in config/backup_manager.yml

require 'yaml'
require 'rubygems'
require '/Users/mike/Development/nibs/lib/backup.rb'

include Backup

PIDFILE = File.expand_path(File.join(File.dirname(__FILE__), "../log/scheduler_pids.yml"))

def run_every(interval_in_seconds)
	fork do
		loop do
			before = Time.now
			yield
			interval = interval_in_seconds - (Time.now - before)
			sleep(interval) if interval > 0
		end
	end
end

hourly_pids, daily_pids, backup_pids = Array.new

SCHEMAS.each do |schema|
	settings = settings(schema)
	interval = hourly_snapshot_interval(schema) * 3600
	
	# Schedule the snapshots...
	unless settings['source'].empty? || settings['snapdir'].empty?
		unless settings['hourly'].empty?
			hourly_pids << run_every(interval) do
				hourly_snapshot = Snapshot.new(schema, 'hourly')
				hourly_snapshot.snap
			end
		end
		unless settings['daily'].empty?
			daily_pids << run_every(86400) do
				daily_snapshot = Snapshot.new(schema, 'daily')
				daily_snapshot.snap
			end
		end
	end
	
	# Now the backups...
	unless settings['source'].empty? || settings['backupdir'].empty?
		backup_pids << run_every(604800) do
			weekly_backup = FullBackup.new(schema)
			weekly_backup.compress
		end
	end
end

pids = {
	:hourly => hourly_pids,
	:daily	=> daily_pids,
	:backup	=> backup_pids
}

# Write each PID to a YAML file for easy killing later.
File.open(PIDFILE, "w") { |pidfile| pidfile.write(pids.to_yaml) }

