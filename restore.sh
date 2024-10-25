#!/bin/bash

############################################
# Restore backup data on Android           #
# By: SteveZMTstudios                      #    
############################################
############################################
#  WARNING:                                #
#  This script is still developing.        #
#  The restore data may not be complete.   #
#  We not guarantee the backup data.       #
#  Use at your own risk.                   #
#  You have been warned!                   #
############################################

DEBUG=0

# verbose when "-v" is passed as an argument
if [[ $1 == "-v" || $DEBUG == "1" ]]; then
    set -x
    alias cp='cp -v'
    alias tar='tar -v'
    alias rm='rm -v'
    alias mkdir='mkdir -v'
fi


ui_print() {
    echo -e "$1"
}


error_handler() {
    echo "Error occurred at line $1."
    echo "Exiting the script."
    # Perform any necessary cleanup here
    rm -rf /tmp/backup_*
    exit 1
}


ui_print "Restore Script"
ui_print "By: SteveZMTstudios"
ui_print "================================"

# check root
if [[ $(id -u) -ne 0 ]]; then
    ui_print "! This script must be run as root."
    exit 1
fi

# check running on Android
if ! command -v pm &> /dev/null; then
    ui_print "! This script must be run on Android."
    exit 1
fi
mkdir -p /sdcard/Backup/
touch /sdcard/Backup/failed_installs.log
touch /sdcard/Backup/failed_user_ids.log
date >> /sdcard/Backup/failed_installs.log
date >> /sdcard/Backup/failed_user_ids.log

backup_dir="/sdcard/EmergencyBak/"
for backup_file in $backup_dir*.tar.gz; do
    # unzip backup data
    temp_restore_dir="/data/local/tmp/restore_$(basename $backup_file .tar.gz)"
    
    if [ -z "$temp_restore_dir" ] || [ "$temp_restore_dir" == "/" ]; then
        ui_print "! Temporary restore directory is null or root, exiting."
        error_handler $LINENO
    fi

    mkdir -p $temp_restore_dir
    tar -xzf $backup_file -C $temp_restore_dir

#   /sdcard/EmergencyBak/
    #            |---<packagename>-backup.tar.gz (now $temp_restore_dir)
    #                    |---|- data
    #                        |   |- app (same as /data/app/*)
    #                        |- data_data
    #                        |  |- data
    #                        |       |- data (same as /data/data/*)
    #                        |- data_user
    #                        |- data_user_de
    #                        |- media_data
    #                        |- media_obb



    # get packagename
    package_name=$(basename $backup_file _backup.tar.gz)

    # install apk
    ui_print "- Restoring $package_name"
    apk_path=$(find $temp_restore_dir/data/app -type f -name "base.apk" | grep "$package_name")
    if ! pm install -r $apk_path; then
        echo "$package_name" >> /sdcard/Backup/failed_installs.log
        ui_print "! Failed to install $package_name, saved to /sdcard/Backup/failed_installs.log"
        continue
    fi

   # get user_id
    user_id=0
    user_id=$(pm list packages -3 -U | grep "$package_name" | awk -F 'uid:' '{print $2}' | grep -o '[1-9][0-9]*$')
    # Format user_id: Remove leading '1' and all leading zeros
    cleaned_value=$(echo "$user_id" | sed 's/^1//' | sed 's/^0*//')
    user_id=$cleaned_value
    if [ -z "$user_id" ]; then
        ui_print "! Failed to get user ID for $package_name"
        echo "$package_name" >> /sdcard/Backup/failed_user_ids.log
        continue
    fi

    # restore app data
    if [ -d "$temp_restore_dir/data_data/data/data" ]; then
        ui_print "- Restoring data for $package_name"
        cp -r $temp_restore_dir/data_data/data/data/$package_name /data/data/
        chown -R u0_a$user_id:u0_a$user_id /data/data/$package_name
    fi

    if [ -d "$temp_restore_dir/data_user/data/user/0" ]; then
        ui_print "- Restoring user data for $package_name"
        cp -r $temp_restore_dir/data_user/data/user/0/$package_name /data/user/0/
        chown -R u0_a$user_id:u0_a$user_id /data/user/0/$package_name
    fi

    if [ -d "$temp_restore_dir/data_user_de/data/user_de/0" ]; then
        ui_print "- Restoring user_de data for $package_name"
        cp -r $temp_restore_dir/data_user_de/data/user_de/0//$package_name /data/user_de/0/
        chown -R u0_a$user_id:u0_a$user_id /data/user_de/0/$package_name
    fi

    if [ -d "$temp_restore_dir/media_obb/data/media" ]; then
        ui_print "- Restoring obb for $package_name"
        cp -r $temp_restore_dir/media_obb/data/media/obb/$package_name /data/media/obb/
        chown -R media_rw:media_rw /data/media/obb/$package_name
    fi

    if [ -d "$temp_restore_dir/media_data/$package_name" ]; then
        ui_print "- Restoring public data for $package_name"
        cp -r $temp_restore_dir/media_data/$package_name /data/media/Android/data/
        chown -R media_rw:media_rw /data/media/Android/data/$package_name
    fi

    # get user_id
 
    # chown owner and user group
    #chown -R system:system /data/app/$package_name

    if [ -z "$temp_restore_dir" ] || [ "$temp_restore_dir" == "/" ]; then
        ui_print "! Temporary restore directory is null or root, exiting."
        error_handler $LINENO
    fi

    if [ -d "$temp_restore_dir" ]; then
        ui_print "- Removing temporary restore directory $temp_restore_dir"
        rm -rf $temp_restore_dir
    fi

done