#!/usr/bin/env ruby
#
# = Nemo Incremental Backup Setup
# 

require 'optparse'
require 'ostruct'
require 'yaml'
require File.join(File.expand_path(File.dirname(__FILE__)), "lib/cocoa_dialog.rb")

include CocoaDialog

License = File.new(File.join(File.dirname(__FILE__), "COPYING"))
Steps = OpenStruct.new

begin
	Steps.one = textbox("License Agreement", License.read, {
		:editable => false, 
		:infotext => "GNU General Public License", 
		:button_1 => "Agree", 
		:button_2 => "Disagree"}).to_i
		
	exit if Steps.one != 1
	
	Steps.two = msgbox("Dependency Check", "Setup needs to determine if you have the required software installed.", {
		:infotext => "This might take a minute. Patience is a virtue. Click 'Ok' to continue.",
		:button_1 => "Ok",
		:button_2 => "Cancel"
	})
	 
rescue
	
end