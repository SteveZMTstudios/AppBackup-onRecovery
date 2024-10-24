#!/sbin/bash

############################################
# Backup script on Recovery Mode           #
# By: SteveZMTstudios                      #    
############################################
#  WARNING:                                #
#  This script is only for emergency use.  #
#  The backup data may not be complete.    #
#  We not guarantee the backup data.       #
#  Use at your own risk.                   #
#  You have been warned!                   #
############################################


error_handler() {
    echo "Error occurred at line $1."
    echo "Exiting the script."
    # Perform any necessary cleanup here
    rm -rf /tmp/backup_*
    exit 1
}

ui_print() {
    
    echo "$1"
#    echo "ui_print $1" > /proc/self/fd/0
#    echo "ui_print $1" > /proc/self/fd/1
}


ui_print "Emergency Backup Script"
ui_print "By: SteveZMTstudios"
ui_print "================================"
ui_print "This script is only for emergency use."
ui_print "The backup data may not be complete."
ui_print "We not guarantee the backup data."
ui_print "Use at your own risk."
ui_print "You have been warned!"
ui_print "================================"



# make backup dir

mkdir -p /sdcard/EmergencyBak/
ui_print "- Backup dir created."

num=0
# read packages.xml
packages_file="/data/system/packages.xml"
grep '<package name=' $packages_file | while read -r line; do
    # get package name and code path
    package_name=$(echo $line | sed -n 's/.*name="\([^"]*\)".*/\1/p')
    code_path=$(echo $line | sed -n 's/.*codePath="\([^"]*\)".*/\1/p')
    #user_id=$(echo $line | sed -n 's/.*userId="\([^"]*\)".*/\1/p')
    ui_print "- Found ${package_name}"
    # edit here to backup specific users app
    user_id=0
    # only backup user app
    if [[ $code_path == /data/app* ]]; then
        num=$((num + 1))
        ui_print "- Selected ${package_name}, the ${num} one."

        # create temp backup dir
        temp_backup_dir="/tmp/backup_$package_name"
        mkdir -p $temp_backup_dir
        rm -rf $temp_backup_dir/*
        # backup APK files, excluding oat files
        ui_print "- Collecting APK files."
        find $code_path -type f ! -name '*.oat' ! -name '*.art' ! -name '*.odex' ! -name '*.vdex' ! -path '*lib*' -exec cp  --parents {} $temp_backup_dir/ \;

        # backup app data, excluding folders or files containing 'cache', 'temp', or 'tmp'
        ui_print "- Collecting /data/data/$package_name."
        mkdir -p $temp_backup_dir/data_data/
        #        find "/data/data/$package_name/" -type f -exec cp  --parents {} $temp_backup_dir/data_data/files \;
        
        #        mkdir -p $temp_backup_dir/data_data/databases
        find "/data/data/$package_name" -type f ! -path '*cache*' ! -path '*temp*' ! -path '*tmp*' -exec cp  --parents "{}" $temp_backup_dir/data_data/ \;

        ui_print "- Collecting /data/user/$user_id/$package_name."
        mkdir -p $temp_backup_dir/data_user
        find "/data/user/$user_id/$package_name" -type f ! -path '*cache*' ! -path '*temp*' ! -path '*tmp*' -exec cp  --parents "{}" $temp_backup_dir/data_user/ \;
        ui_print "- Not found is normal."

        ui_print "- Collecting /data/user_de/$user_id/$package_name."
        mkdir -p $temp_backup_dir/data_user_de
        find "/data/user_de/$user_id/$package_name" -type f ! -path '*cache*' ! -path '*temp*' ! -path '*tmp*' -exec cp  --parents "{}" $temp_backup_dir/data_user_de/ \;
        ui_print "- /data/user_de${package_name} collected. Not found is normal."

        ui_print "- Collecting /data/media/obb/$package_name."
        mkdir -p $temp_backup_dir/media_obb
        find "/data/media/obb/$package_name" -type f ! -path '*cache*' ! -path '*temp*' ! -path '*tmp*' -exec cp  --parents "{}" $temp_backup_dir/media_obb/ \;
        ui_print "- Not found is normal."

        ui_print "- Collecting /data/media/Android/data/$package_name."
        mkdir -p $temp_backup_dir/media_data
        find "/data/media/$user_id/Android/data/$package_name" -type f ! -path '*cache*' ! -path '*temp*' ! -path '*tmp*' -exec cp  --parents "{}" $temp_backup_dir/media_data/ \;
        ui_print "- /data/media/Android/data${package_name} collected. "

        ui_print "- ${package_name} is tar.gz ing...  Please wait."
        ui_print "[i] Although it seems to be stuck, it is actually working."
        # zip backup data
        if ! tar -czf /sdcard/EmergencyBak/${package_name}_backup.tar.gz -C $temp_backup_dir .; then
            ui_print "! Failed to create tar.gz for ${package_name}."
            error_handler $LINENO
        fi

        # delete temp_backup_dir
        rm -rf $temp_backup_dir
        ui_print "- ${package_name} is backuped."

    fi
done

# zip the entire backup directory
ui_print "- Zipping the entire backup directory."
ui_print "[i] Although it seems to be stuck, it is actually working."
ui_print "[i] it will take a long time, please be patient."
ui_print "<!> DO NOT EXIT OR REBOOT THE DEVICE <!>"
if ! tar -czvf /sdcard/complete_backup.tar.gz -C /sdcard EmergencyBak; then
    ui_print "! Failed to create complete_backup.tar.gz."
    error_handler $LINENO
else
    ui_print "- The entire backup directory is zipped successfully."
fi

ui_print "Backup completed. Total zipped ${num} apps."
ui_print "Please copy /sdcard/complete_backup.tar.gz to your PC."
ui_print "The detailed backup data is in /sdcard/EmergencyBak/."