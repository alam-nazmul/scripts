#!/bin/bash

# Source directory path to search for files
source_directory="/var/lib/celloscope/csb/csb-platform/data/localphotoserver/customer"

# Destination directory path to copy files
destination_directory="/var/lib/celloscope/csb/csb-platform/data/localphotoserver/copy_data_daily/2023_dec"




# Find files modified between Sept 1, 2023, and Sept 30, 2023
find "$source_directory" -type f -newermt 2023-11-01 ! -newermt 2023-12-01 -exec cp -v -t "$destination_directory" {} +

echo "Files from Nov 2023, have been copied to $destination_directory"