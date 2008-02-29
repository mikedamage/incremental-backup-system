role :files, "backup@69.115.42.171"

desc "Update the backup scripts on the remote server"
task :update do
  run "cd /Users/backup/NemoBackup && /usr/local/bin/svn update"
end

desc "Updates the launchd daemon that schedules the backups and tells launchctl to reload it."
task :launchd do
  run "cd /Users/backup/NemoBackup && sudo cp com.backup.SnapshotScript.plist /Library/LaunchDaemons/"
  run "sudo launchctl unload com.backup.SnapshotScript && sudo launchctl load /Library/LaunchDaemons/com.backup.SnapshotScript.plist"
end