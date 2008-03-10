#!/usr/bin/env ruby

begin
	require 'commandline'
rescue LoadError
	require 'rubygems'
	retry
end

class Backup < CommandLine::Application
	def initialize
		version							"0.1"
		author							"Mike Green"
		copyright						"2008"
		synopsis						""
		short_description
		long_description
	end
end