#!/bin/bash
# Daily Snapshot Backup
# by Mike Green
## Makes incremental backups of a directory (or whole drive) for the last 7 days.
## Most recent backup is backup.0

# directory to be backed up
BDIR=/home/3866/domains;

# directory where the backups are stored
BDEST=/home/3866/data/backup;

# delete the oldest snapshot, if it exists
if [ -d $BDEST/backup.6 ] ; then			\
	rm -rf $BDEST/backup.6 ; 				\
fi ;

# shift the middle snapshots back by 1
if [ -d $BDEST/backup.5 ] ; then			\
	mv $BDEST/backup.5 $BDEST/backup.6 ;	\
fi;
if [ -d $BDEST/backup.4 ] ; then			\
	mv $BDEST/backup.4 $BDEST/backup.5 ;	\
fi;
if [ -d $BDEST/backup.3 ] ; then			\
	mv $BDEST/backup.3 $BDEST/backup.4 ;	\
fi;
if [ -d $BDEST/backup.2 ] ; then			\
	mv $BDEST/backup.2 $BDEST/backup.3 ;	\
fi;
if [ -d $BDEST/backup.1 ] ; then			\
	mv $BDEST/backup.1 $BDEST/backup.2 ;	\
fi;

# make a hard-link-only copy of the most recent backup,
# thus freezing it in time for all to see and recording only the changes.
if [ -d $BDEST/backup.0 ] ; then			\
	cp -al $BDEST/backup.0 $BDEST/backup.1 ; \
fi;

# finally, we rsync the current files into backup.0 and change
# the time stamp to reflect the date and time of the backup.
rsync -va --delete $BDIR/ $BDEST/backup.0 ;
touch $BDEST/backup.0 ;

# fin
exit 0;