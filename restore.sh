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


ui_print "Restore Script"
ui_print "By: SteveZMTstudios"
ui_print "================================"

if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

backup_dir="/sdcard/EmergencyBak/"
for backup_file in $backup_dir*.tar.gz; do
    # unzip backup data
    temp_restore_dir="/tmp/restore_$(basename $backup_file .tar.gz)"
    mkdir -p $temp_restore_dir
    tar -xzvf $backup_file -C $temp_restore_dir

    # get packagename
    package_name=$(basename $backup_file _backup.tar.gz)

    # install apk
    if ! pm install -r $temp_restore_dir/$package_name.apk; then
        echo "$package_name" >> /sdcard/failed_installs.log
    fi

    # restore apk data
    cp -r $temp_restore_dir/data_data/$package_name/data/data /data/data
    cp -r $temp_restore_dir/data_user/$package_name/data/user/0 /data/user/0
    cp -r $temp_restore_dir/data_user_de/$package_name/data/user_de/0 /data/user_de/0
    cp -r $temp_restore_dir/media_obb/$package_name/data/media /data/media/obb/
    cp -r $temp_restore_dir/media_data/$package_name /data/media/Android/data/

    # chown owner and user group
    chown -R system:system /data/app/$package_name
    chown -R u0_a$user_id:u0_a$user_id /data/user/$package_name
    chown -R u0_a$user_id:u0_a$user_id /data/user_de/$package_name
    chown -R media_rw:media_rw /data/media/obb/$package_name
    chown -R media_rw:media_rw /data/media/Android/data/$package_name

    # remove temp dir
    rm -rf $temp_restore_dir
done