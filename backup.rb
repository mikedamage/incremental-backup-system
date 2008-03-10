#!/usr/bin/env ruby
# = Incremental Backup
# Made to be run via Cron or Launchd at specified intervals, this script takes a snapshot of 
# the specified folder(s). It stores a specified number of incremental daily snapshots, as well
# as an archive of compressed weekly and monthly backups.
#
# = Usage
# backup.rb [-h|--help] [-s|--snapshot] [-a|--archive] [source_folder] destination_folder
#
# help::
#		This message.
# snapshot:: 
#		Takes an incremental snapshot. This is the default mode.
# archive::
# 	Creates a GZipped archive of the most recent snapshot in the source folder.
# 	Good for creating weekly and monthly archives of the Snapshot folder.
# source_folder::
# 	Defaults to the current working directory ENV['PWD']

#	TODO: Consider using a hash inside the script instead of command line arguments for configuration.
#	i.e. @config = { :snaps_to_keep => 7, :ignore => nil, :source => "~/", :destination => "~/Backup" }

  
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
	opts.on("-m", "--max-snaps [MAX_SNAPS]", "Maximum number of snapshots to keep before deleting old ones.") do |m|
		@options.max_snaps = m
	end
	opts.on_tail("-h", "--help", "Shows this message") do
		RDoc.usage()
		exit
	end
end

def snapshot(source, destination)
	snapshots = Dir.entries(destination).delete_if {|f| d == "." or d == ".."}
	snapshots = snapshots.reverse
	
	if snapshots[0] >= "Snapshot." + @options. # need to convert snapshot number to integer
	else
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
		puts "Creating snapshot of " + ARGV[0] + "..."
		#snapshot(ARGV[0], ARGV[1])
	end
rescue OptionParser::ParseError => e
  puts e
  RDoc.usage()
end

