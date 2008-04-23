#!/usr/bin/env ruby
#
# = Nemo Backup Manager
#
# Author::		Mike Green <mike.is.green@gmail.com>
# Date::			03-11-2008
# Copyright::	Copyright (c) 2008 Mike Green
# License::		GNU General Public License
#
# == Summary
#
#	This script reads from a YAML file inside the lib directory (settings.yml) that contains
# profiles for different drives to back up. See settings.yml.example for more info. Specify
# which drives in the file to back up via command line arguments. Optionally, you can specify
# a different settings file to read from.
#
# == Usage

require 'rdoc/usage'
require 'optparse'
require 'fileutils'
require 'pathname'
require 'lib/backup.rb'

opts = OptionParser.new do |opts|
	opts.banner = "backup.rb [-uhpgA] drive_1 [drive_2, drive_3, etc.]"
	opts.on("-p", "--prefs=FILE", "Use the specified preferences file instead of the default (#{File.expand_path(File.dirname(__FILE__))}/lib/settings.yml)") do |p|
		Backup::USER_PREFS = p
	end
	opts.on("-g", "--gcp [PATH]", "Use GNU \"cp -a\" to copy hardlinks in snapshots (uses \"cpio\" by default)") do |gcp|
		use_gcp = true
		unless gcp.empty?
			gcp_executable = gcp
		else
			gcp_executable = "/opt/local/bin/gcp"
		end
	end
	opts.on("-A", "--archive", "Create a compressed archive of the latest snapshot instead of taking a new one.") do
		Backup::ARCHIVE = true
	end
	opts.on("-u", "--usage", "Only print the usage summary") do
		puts opts
		exit(0)
	end
	opts.on_tail("-h", "--help", "Shows credits, summary, and usage information") do
		RDoc.usage_no_exit()
		puts opts
		exit
	end
end



=begin
	opts.parse!(ARGV)
	if $prefs.archive
		puts "archiving " + ARGV[0] + " to " + ARGV[1]
		#archive(ARGV[0], ARGV[1])
	else
		puts "Creating snapshot of: " + ARGV[0]
		puts "Sending to: " + ARGV[1]
		puts "max snapshots to keep: " + $prefs.max_snaps.to_s
		puts "Path to ignore patterns: " + $prefs.ignore if $prefs.ignore
		# Snapshot.create(ARGV[0], ARGV[1])
	end
rescue OptionParser::ParseError => e
  puts e
	@log.fatal('Caught error, exiting...')
	@log.fatal(e)
  RDoc.usage()
=end

