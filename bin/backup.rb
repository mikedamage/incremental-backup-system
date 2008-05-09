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
require '../lib/backup.rb'

Prefs = OpenStruct.new({
	"delete" => true,
	"config" => File.expand_path(File.join(File.dirname(__FILE__), "../config/backup_manager.yml"))}),
})

args = OptionParser.new do |opts|
	opts.banner = "backup.rb [options] drive_1 [drive_2, drive_3, etc.]"
	opts.on("-n", "--no-delete", "Don't delete files no longer found on source volume") do
		Prefs.delete = false
	end
	opts.on("-u", "--usage", "Only print the usage summary") do
		puts opts
		exit(0)
	end
	opts.on_tail("-h", "--help", "Shows credits, summary, and usage information") do
		RDoc.usage_no_exit("Summary")
		puts opts
		exit
	end
end

begin
	args.parse!
	
rescue OptionParser::ParseError => e
	LOG.error(e)
	puts e
end