#!/usr/bin/env ruby
#
# = Nemo Backup Manager
#
# Author::		Mike Green <mike.is.green@gmail.com>
# Date::			05-09-2008
# Copyright::	Copyright (c) 2008 Mike Green
# License::		GNU General Public License
#
# == Summary
#	This script reads from a YAML file inside the lib directory (settings.yml) that contains
# profiles for different drives to back up. See settings.yml.example for more info. Specify
# which drives in the file to back up via command line arguments. Optionally, you can specify
# a different settings file to read from.
#
# == Usage

require 'rdoc/usage'
require 'optparse'
require 'ostruct'
require 'fileutils'
require 'pathname'
require File.expand_path(File.join(File.dirname(__FILE__), "../lib/backup.rb"))
require File.expand_path(File.join(File.dirname(__FILE__), "../lib/project_manager.rb"))

Prefs = OpenStruct.new({
	"delete" => true,
	"config" => File.expand_path(File.join(File.dirname(__FILE__), "../config/backup_manager.yml")),
	"snapshot" => false,
	"archive" => false,
	"interval" => nil
})

args = OptionParser.new do |opts|
	opts.banner = "backup.rb (--archive|--snapshot=interval) drive_1 [drive_2, drive_3, etc.]"
	opts.on("-a", "--archive", "Creates a compressed full backup of selected schemata.") do
		Prefs.archive = true
	end
	opts.on("-s", "--snapshot INTERVAL", [:hourly, :daily], "Take an incremental snapshot for the selected interval (hourly or daily)") do |opt|
		Prefs.snapshot = true
		Prefs.interval = opt
	end
	opts.on("-n", "--no-delete", "Don't delete files that were deleted from source volume") do
		Prefs.delete = false
	end
	opts.on_tail("-h", "--help", "Shows credits, summary, and usage information") do
		RDoc.usage_no_exit("Summary")
		puts opts
		exit
	end
	if ARGV.empty?
		puts opts
		exit
	end
end


begin
	args.parse!
	ARGV.each do |schema|
		if Prefs.snapshot
			sh = Snapshot.new(schema, Prefs.interval)
			sh.snap
		elsif Prefs.archive
			fb = FullBackup.new(schema)
			fb.compress if fb.enough_room?
		elsif Prefs.snapshot && Prefs.archive
			puts "One or the other, bud. You can't take a snapshot and a backup at the same time"
			exit
		end
	end
rescue OptionParser::ParseError => e
	#LOG.error(e)
	puts e
end