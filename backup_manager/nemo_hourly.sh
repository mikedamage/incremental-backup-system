#!/bin/bash
#
##	Nemo Daily Incremental Backup Script
##
##	Created 12-15-2007.
##	Copyright (c) 2007 Mike Green. All rights reserved.


## Drives to Backup:
VAULT=/Volumes/Vault
DUNDER=/Volumes/Red
MIFFLIN=/Volumes/Mifflin

## Backup Destinations:
VAULT_MIRROR=/volumes/Mirror/_Vault/Snapshots

## Load PATH:
source /Users/backup/.bash_login;

## First, check to see if volumes are mounted. If they aren't, then try to mount them.


## Begin backup with the Vault
echo "[Begin backup for `date`]" ;

## Delete the oldest backup if it exists
if [ -d $VAULT_MIRROR/Snapshot.6 ]; then			\
	rm -rf $VAULT_MIRROR/Snapshot.6;				\
	echo "Deleting the oldest snapshot..." ;\
fi;

## Bump each snapshot back a number
if [ -d $VAULT_MIRROR/Snapshot.5 ]; then			\
	echo "Aging Snapshot 5..." ;
	mv $VAULT_MIRROR/Snapshot.5 $VAULT_MIRROR/Snapshot.6 ;
fi
if [ -d $VAULT_MIRROR/Snapshot.4 ]; then			\
	echo "Aging Snapshot 4..." ;
	mv $VAULT_MIRROR/Snapshot.4 $VAULT_MIRROR/Snapshot.5 ;
fi
if [ -d $VAULT_MIRROR/Snapshot.3 ]; then			\
	echo "Aging Snapshot 3..." ;
	mv $VAULT_MIRROR/Snapshot.3 $VAULT_MIRROR/Snapshot.4 ;
fi
if [ -d $VAULT_MIRROR/Snapshot.2 ]; then			\
	echo "Aging Snapshot 2..." ;
	mv $VAULT_MIRROR/Snapshot.2 $VAULT_MIRROR/Snapshot.3 ;
fi
if [ -d $VAULT_MIRROR/Snapshot.1 ]; then			\
	echo "Aging Snapshot 1..." ;
	mv $VAULT_MIRROR/Snapshot.1 $VAULT_MIRROR/Snapshot.2 ;
fi

## Now make a hardlink-only copy of the most recent backup
if [ -d $VAULT_MIRROR/Snapshot.0 ] ; then			\
	echo "Aging Snapshot 0..." ;
##	this uses GNU cp command installed from MacPorts
	gcp -al $VAULT_MIRROR/Snapshot.0 $VAULT_MIRROR/Snapshot.1 ;
##	the line below uses standard OS X cpio command
#	cd $VAULT_MIRROR/Snapshot.0 && find . -print | cpio -dplm $VAULT_MIRROR/Snapshot.1 ;
fi

## Finally, rsync the current files into Snapshot.0 and change their time
## stamp to reflect the time & date of backup.
rsync -va --delete $VAULT/ $VAULT_MIRROR/Snapshot.0/ ;
touch $VAULT_MIRROR/Snapshot.0 ;
echo "[Finished Backup At `date`]"
echo " "
sleep 10 ;
exit 0 ;




