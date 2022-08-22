#!/bin/bash


# This is the primary main_gitlab server, which IP is 172.17.5.99. 
# We have a secondary backup_gitlab server, which IP is 172.17.4.99.

# Assign the variables.
USER='root';
REMOTE_HOST='172.17.4.99';
METADATA_LOCAL_PATH='/var/opt/gitlab/backups/';
METADATA_REMOTE_PATH='/var/opt/gitlab/backups/';
CORE_DATA_LOCAL_PATH='/etc/gitlab/';
CORE_DATA_REMOTE_PATH='/opt/backup/';


# gitlab backup create
echo "Get ready for gitlab backup metadata (it will take 10-15 mins)"
gitlab-backup create force=yes


# Get the most recent file and assign it to most RECENT file.
cd ${METADATA_LOCAL_PATH};
RECENT=$(ls -Art | tail -n 1);
echo "${RECENT} , this is the most recent file"
sleep 3s


# Sent secrect files to backup gitlab via rsync.
echo ">> >> >> Sending GitLab secrect files to gitlab_backup server >> >> >>"
rsync -av ${CORE_DATA_LOCAL_PATH}/gitlab* ${USER}@${REMOTE_HOST}:${CORE_DATA_REMOTE_PATH};
echo -e "GitLab secrect files are sent. \nPlease wait 3 sec"
sleep 3s


# Sent backup files to backup gitlab via rsync.
echo ">> >> >> Copying GitLab Metadata file to gitlab_backup server >> >> >>"
rsync -av ${METADATA_LOCAL_PATH}${RECENT} ${USER}@${REMOTE_HOST}:${METADATA_REMOTE_PATH}${RECENT};
echo -e "GitLab metadata file is sent. \nPlease wait 3 sec"
sleep 3s


# Restore the backup file.
echo ">> >> >> Staring Restore precess.... >> >> >>"


if [ $? != "0" ]
then
	echo "Gitlab Metadata file isn't sent to backup GitLab server. So, we reject the next activity..."
	exit 1
else
	ssh ${USER}@${REMOTE_HOST} bash /root/daily_restore_script_for_gitlab.sh
	exit 0
fi

