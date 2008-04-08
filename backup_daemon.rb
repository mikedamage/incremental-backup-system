#!/usr/bin/env ruby
#
# = Incremental Backup
#
# Author::		Mike Green <mike.is.green@gmail.com>
# Date::			04-07-2008
# Copyright::	Copyright (c) 2008 Mike Green
# License::		GNU General Public License

require 'rubygems'
require 'daemons'

Daemons.run('backup.rb')