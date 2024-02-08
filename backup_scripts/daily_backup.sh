#!/bin/bash

source_directory="/var/lib/celloscope/csb/csb-platform/data/localphotoserver/customer"
today=$(date "+%Y-%m-%d")
destination_directory="/var/lib/celloscope/csb/csb-platform/data/localphotoserver/copy_data_daily/$today"
yesterday=$(date -d "yesterday" +%Y-%m-%d)
remote_path="/var/lib/celloscope/csb/csb-platform/data/localphotoserver/copy_images"
remote_host="192.168.190.60"
remote_user="ubuntu"



mkdir -p $destination_directory
find "$source_directory" -type f -newermt "$yesterday" ! -newermt "$yesterday+1 day" -exec cp -v {} "$destination_directory" \;

cd /var/lib/celloscope/csb/csb-platform/data/localphotoserver/copy_data_daily
tar -cvzf ${today}.tar.gz ${today}

recent_file=$(ls -Art | tail -n 1);

rsync -av $recent_file $remote_user@$remote_host:$remote_path;