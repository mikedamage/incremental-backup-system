#!/usr/bin/env ruby
#
# = Incremental Backup
#
# Author::		Mike Green <mike.is.green@gmail.com>
# Date::			03-11-2008
# Copyright::	Copyright (c) 2008 Mike Green
# License::		GNU General Public License
#
# == Summary
#
#	Made to be run via Cron or Launchd at specified intervals, this script takes a snapshot of 
#	the specified folder(s). It stores a specified number of incremental daily snapshots, as well
#	as an archive of compressed weekly and monthly backups.
#
# == Usage

require 'rdoc/usage'
require 'optparse'
require 'ostruct'
require 'fileutils'
require 'pathname'
require 'logger'
(Pathname.new(__FILE__).dirname + "lib").children.each {|f| require f}

# Set the default options.
@@options = OpenStruct.new
@@options.archive = false
@@options.ignore = nil
@@options.max_snaps = 14
@@options.source = "./"
@@options.logfile = '/Users/mike/Desktop/backup.log'

@@log = Logger.new(@@options.logfile, 10, 1024000)
@@log.level = Logger::INFO

opts = OptionParser.new do |opts|
	opts.banner = "backup.rb [-a|--archive] [-i|--ignore] [-m|--max-snaps snapshots_to_keep] [source] destination"
	
	opts.on("-a", "--archive", "Create an archive of the most recent backup in the source directory") do |a|
		@options.archive = a
	end
	opts.on("-i", "--ignore IGNORE", "Pattern of files to ignore, or path to file with patterns") do |i|
		@options.ignore = i
	end
	opts.on("-m", "--max-snaps MAX_SNAPS", Integer, "Number of snapshots to keep before deleting old ones.") do |m|
		if m < 2
			@options.max_snaps = 2
		else
			@options.max_snaps = m
		end
	end
	opts.on("-u", "--usage", "Only print the usage summary") do
		puts opts
		exit
	end
	opts.on_tail("-h", "--help", "Shows credits, summary, and usage information") do
		RDoc.usage_no_exit()
		puts opts
		exit
	end
end

=begin
	opts.parse!(ARGV)
	if @options.archive
		puts "archiving " + ARGV[0] + " to " + ARGV[1]
		#archive(ARGV[0], ARGV[1])
	else
		puts "Creating snapshot of: " + ARGV[0]
		puts "Sending to: " + ARGV[1]
		puts "max snapshots to keep: " + @options.max_snaps.to_s
		puts "Path to ignore patterns: " + @options.ignore if @options.ignore
		# Snapshot.create(ARGV[0], ARGV[1])
	end
rescue OptionParser::ParseError => e
  puts e
	@log.fatal('Caught error, exiting...')
	@log.fatal(e)
  RDoc.usage()
=end

