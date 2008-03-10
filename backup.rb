#!/usr/bin/env ruby
#
# = Incremental Backup
#	Author::	Mike Green
#	Date::		3/10/08
#	Copyright::	2008, Mike Green
#	License:: 	GNU General Public License
#
# == Summary
#	Made to be run via Cron or Launchd at specified intervals, this script takes a snapshot of 
#	the specified folder(s). It stores a specified number of incremental daily snapshots, as well
#	as an archive of compressed weekly and monthly backups.
  
require 'rdoc/usage'
require 'optparse'
require 'ostruct'
require 'fileutils'

@options = OpenStruct.new
@options.archive = false
@options.ignore = nil
@options.max_snaps = 14
@options.source = "./"

opts = OptionParser.new do |opts|
	opts.banner = "Usage: backup.rb [-a|--archive] [-i|--ignore] [-m|--max-snaps snapshots_to_keep] [source] destination"
	
	opts.on("-a", "--archive", "Create an archive of the most recent backup in the source directory") do |a|
		@options.archive = a
	end
	opts.on("-i", "--ignore [IGNORE]", "Pattern of files to ignore, or path to file with patterns") do |i|
		@options.ignore = i
	end
	opts.on("-m", "--max-snaps [MAX_SNAPS]", Integer, "Maximum number of snapshots to keep before deleting old ones.") do |m|
		if m <= 1
			@options.max_snaps = 2
		else
			@options.max_snaps = m
		end
	end
	opts.on_tail("-h", "--help", "Shows this message") do
		RDoc.usage_no_exit()
		puts opts
		exit
	end
end

def snapshot(source, destination)
	snapshots = Dir.entries(destination).delete_if {|d| d == "." or d == ".."}
	snapshots = snapshots.reverse
	oldest = destination + "/" + snapshots[0]
	@rev_filter = Regexp.new('\d\d')
	
	# Delete oldest directory if number of snapshots is equal to or greater than the limit
	if snapshots[0].slice(rev_filter).to_i >= @options.max_snaps
		FileUtils.remove_dir(oldest, force = true)
		snapshots = Dir.entries(destination).delete_if {|d| d == "." or d == ".."}
	end
	
	# Bump each snapshot back one
	snapshots.each do |s|
		num = s.slice(@rev_filter).to_i
		old_path = destination + "/" + s
		new_path = destination + "/Snapshot." + (num + 1)
		FileUtils.mv(old_path, new_path)
	end
end

def archive(source, destination)
end

begin
	opts.parse!(ARGV)
  
	if @options.archive
		puts "archiving " + ARGV[0] + " to " + ARGV[1]
		#archive(ARGV[0], ARGV[1])
	else
		puts "Creating snapshot of: " + ARGV[0]
		puts "Sending to: " + ARGV[1]
		puts "max snapshots to keep: " + @options.max_snaps.to_s
		puts "Path to ignore patterns: " + @options.ignore if @options.ignore
		puts "\nCalling method: snapshot(" + ARGV[0] + ", " + ARGV[1] + ")"
		#snapshot(ARGV[0], ARGV[1])
	end
rescue OptionParser::ParseError => e
  puts e
  RDoc.usage()
end

