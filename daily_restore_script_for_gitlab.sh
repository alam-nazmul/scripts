#!/bin/bash

# This is the backup_gitlab server, which IP is 172.17.5.99.
# We will restore daily metadata backup file.

# Assign the variables.
METADATA_LOCAL_PATH='/var/opt/gitlab/backups/';
CORE_DATA_LOCAL_PATH='/opt/backup/';
SERVICES="unicorn puma sidekiq";
CMDS="reconfigure restart";

# Change permission for gitlab secrect file
cd ${CORE_DATA_LOCAL_PATH};
chown ubuntu:ubuntu gitlab*
ls -lh; echo "Please wait for 3s"; sleep 3s;


# Get the most recent file and assign it to most RECENT file.
cd ${METADATA_LOCAL_PATH};
RECENT=$(ls -Art | tail -n 1);
chown git:git ${RECENT}
ls -lh; echo "Please wait for 3s"; sleep 3s;


# This will be most resent file for restore metadata file
echo -e "Creating duplicate file from metadata file for restore. \nIt may takes 10-15 mins. \nPlease wait..."
cp -av ${RECENT} ${RECENT::-18}
ls -lh; echo "Please wait for 3s"; sleep 3s;


# Change permission for gitlab secrect file
BACKUP_FILE=$(ls -Art | tail -n 1);
chown git:git ${BACKUP_FILE}
ls -lh; echo "Please wait for 3s"; sleep 3s;


# Stop all services
for SERVICE in ${SERVICES}
do
        gitlab-ctl stop ${SERVICE}
        echo "${SERVICE} is stopped"
done


# Restore the backup file
echo "Starting GitLab restoring with ${RECENT} file"
gitlab-backup restore BACKUP=${BACKUP_FILE} force=yes


# Copy the secrects file to safe place
if [ $? != "0" ]
then
	echo "Restore has not done successfully. ..."
	exit 1
else
	cp ${CORE_DATA_LOCAL_PATH}gitlab* /etc/gitlab
	echo "Cloning done for secrect files"
        exit 0
fi


# Restart this server
for CMD in ${CMDS}
do
        gitlab-ctl ${CMD}
	echo "GitLab is ${CMD}ed"
done

gitlab-rake gitlab:check SANITIZE=true


# Start all services
for SERVICE in ${SERVICES}
do
        gitlab-ctl start ${SERVICE}
        echo "${SERVICE} is started"
done


# Remove the restore file after activity
cd ${METADATA_LOCAL_PATH};
if [ "$? == 0" ]
then
	rm -rf ${BACKUP_FILE}
	echo "Restore file is removed..."
else
	echo "Restore file exists, the file is not removed due to some error..."
fi

