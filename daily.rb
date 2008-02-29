#!/usr/bin/env ruby
#
#  Daily Differential Backup Script
#
#  Created by Mike Green on 2008-01-27.
#  Copyright (c) 2008. All rights reserved.

require 'rubygems'

# Places to back up from
Dir.foreach("/Volumes/Mirror/_Vault/Snapshots") do |f|
  puts File.stat(f).mtime unless (f == ".DS_Store")
end


   


