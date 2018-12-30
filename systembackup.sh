#!/bin/bash
#
# customized system backup script - 
# creates a tar.gz archive of root and home filesystems 
# filtering out unneeded directories and undesired content
# 
# * home filesystem: iso files are ommitted
#


# ==========================================================
# variable definitions
# ==========================================================
hostname=$HOSTNAME
date=$(date +%Y.%m.%d_%H.%M)
bkup_dir=/mnt/backup/$HOSTNAME
bkup_filename=backup_$hostname\_$date
bkup_logfile=$bkup_dir/backups.log


# ----------------------------------------------------------
# change directory to the system root
# ----------------------------------------------------------
cd /


# ----------------------------------------------------------
# verify backup share is mounted, else mount it
# ----------------------------------------------------------
mountpoint -q /mnt/backup || \
	mount.nfs storage.lab.acrocker.com:/srv/nfs/backup /mnt/backup


# ----------------------------------------------------------
# verify host-specific directory exists, else create it
# ----------------------------------------------------------
if [[ ! -d $bkup_dir ]]; then
	mkdir $bkup_dir
fi


# ==========================================================
# ROOT
# ==========================================================
# make backup of root filesystem in backup share
# ----------------------------------------------------------
fsystem=root
tar -cvzf $bkup_dir/$bkup_filename\_$fsystem.tar.gz	\
	--one-file-system	\
	--exclude=/home	\
	--exclude=/proc	\
	--exclude=/tmp	\
	--exclude=/mnt	\
	--exclude=/dev	\
	--exclude=/sys	\
	--exclude=/run	\
	--exclude=/media	\
	--exclude=/var/log	\
	--exclude=/var/cache/pacman	\
	--exclude=/var/cache/apt	\
	--exclude=/var/cache/yum	\
	--exclude=/home/*/.gvfs	\
	--exclude=/home/*/.cache	\
	--exclude=/home/*/.local/share/Trash	\
	--exclude=/*.iso	\
	/


# ----------------------------------------------------------
# log backup completeion
# ----------------------------------------------------------
echo "backup complete -- host: $hostname\ -- type: $fsystem\ -- $date " >> $bkup_logfile


# ==========================================================
# HOME
# ==========================================================
# make backup of home filesystem in backup share
# ----------------------------------------------------------
fsystem=home
tar -cvzf $bkup_dir/$bkup_filename\_$fsystem.tar.gz	\
	--one-file-system	\
	--exclude=/proc	\
	--exclude=/tmp	\
	--exclude=/mnt	\
	--exclude=/dev	\
	--exclude=/sys	\
	--exclude=/run	\
	--exclude=/media	\
	--exclude=/var/log	\
	--exclude=/var/cache/pacman	\
	--exclude=/var/cache/apt	\
	--exclude=/var/cache/yum	\
	--exclude=/home/*/.gvfs	\
	--exclude=/home/*/.cache	\
	--exclude=/home/*/.local/share/Trash	\
	--exclude=/*.iso	\
	/home


# ----------------------------------------------------------
# log backup completeion
# ----------------------------------------------------------
echo "backup complete -- host: $hostname\ -- type: $fsystem\ -- $date " >> $bkup_logfile


