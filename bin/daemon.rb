# Nemo Backup Daemon
# Loaded by backup_controller.rb and runs in the background

require File.expand_path(File.join(File.dirname(__FILE__), "../lib/backup.rb"))

include Backup

schedule = Hash.new

SCHEMAS.each do |schema|
	schedule[schema] = backup_times(schema)
end