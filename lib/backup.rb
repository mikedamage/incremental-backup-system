require 'ostruct'
require 'logger'
require 'snapshot.rb'
require 'archive.rb'

class Backup
	
	@@log 				= Logger.new(@@prefs.logfile, 10, 256000)
	@@log.level 	= Logger::INFO
	
	@@prefs 					= OpenStruct.new
	@@prefs.snapshots = 14
	@@prefs.logfile		= File.join(File.expand_path(File.dirname(__FILE__)), "../log/backup.log")
	
	
end