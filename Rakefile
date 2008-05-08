require 'yaml'
require 'fileutils'

namespace :backup do
	desc "Creates directories for each of the schemata listed in config/backup_manager.yml"
	task :bootstrap do
		settings = YAML.load_file(File.join(File.dirname(__FILE__), "config/backup_manager.yml"))
		
		settings.keys.each do |key|
			schema = settings[key]
			FileUtils.mkpath(schema["backup directory"]) if schema["backup directory"] unless FileTest.exist?(schema["backup directory"])
			# TODO: Finish the bootstrap rake task
		end
	end
		
end

namespace :git do
	desc "Stages new & modified files for commit."
	task :add do
		system "git add ."
		system "git status"
	end
	
	namespace :config do
		desc "Create remote branches in config file"
		task :remotes do
			puts "this task does nothing right now"
		end
	end
	
	namespace :push do
		desc "Push master branch to origin"
		task :origin do 
			system "git push origin master"
		end
		
		desc "Push master branch to GitHub"
		task :hub do
			system "git push github master"
		end
	end
	
	desc "Commits changes to repository"
	task :commit do
		print "Commit Message: "
		msg = STDIN.gets
		system "git commit -m \"#{msg}\""
	end
	
	desc "Shows last 3 commits"
	task :log do
		system "git log -n 3"
	end
end