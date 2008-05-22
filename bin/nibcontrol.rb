#!/usr/bin/env ruby
#
# = NIBS Daemon Controller
# Copyright::	Copyright (C) 2008, Mike Green
# Email::			mike@fifthroomcreative.com
# URL::				http://www.fifthroomcreative.com
# License::		GNU General Public License

require 'rubygems'
require 'daemons'

Daemons.run('scheduler.rb', {:mode => :exec, :app_name => "nibcontrol", :log_output => true})