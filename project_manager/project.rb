#!/usr/bin/env ruby
#
# = Project Archive Manager
# Author 		::	Mike Green <mike@fifthroomcreative.com>
# Date			::	04-22-2008
# Copyright ::	Copyright 2008, Mike Green
# License		::	GNU General Public License
#
# == Summary
#
# == Usage
#

require 'optparse'
require 'rdoc/usage'
require 'fileutils'
require 'pathname'
require 'lib/project'

opts = OptionParser.new do |opts|
	opts.banner = "project [-h] [archive|dormant|info|list|restore] folder_name"
	opts.on("-h", "--help", "Shows usage information")
end
