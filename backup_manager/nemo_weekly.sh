#!/bin/bash
#
## *Name:	Nemo Weekly Backup
## *Date:	01-27-2008
## *Author:	Mike Green. All rights reserved.
##
## Creates a compressed archive of the last 7 snapshots and gives it a time-stamp.
## It will keep storing archives until the disk runs out of space. Then it will
## start deleting the oldest archives to make room for new ones.

unset $PATH
export PATH="/bin:/sbin:/opt/local/bin:/sw/bin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

DAILY_SNAPS=/Volumes/Mirror/_Vault/Snapshots	# daily snapshot directory
DEEP_FREEZE=/Volumes/Mirror/_Vault/Archives		# long-term archive storage directory

tar xvzf $DEEP_FREEZE/weekly_`date +%F`.tar.gz $DAILY_SNAPS/Snapshot.0/