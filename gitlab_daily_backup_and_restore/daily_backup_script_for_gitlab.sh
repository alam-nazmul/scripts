#!/bin/bash


# This is the primary main_gitlab server, which IP is 172.17.5.99. 
# We have a secondary backup_gitlab server, which IP is 172.17.4.99.

# Assign the variables.
USER='root';
REMOTE_HOST='172.16.4.62';
METADATA_LOCAL_PATH='/var/opt/gitlab/backups/';
METADATA_REMOTE_PATH='/var/opt/gitlab/backups/';
CORE_DATA_LOCAL_PATH='/etc/gitlab/';
CORE_DATA_REMOTE_PATH='/opt/backup/';
LOG_FILE=/var/opt/gitlab/logs/daily_"$(date +%Y-%m-%d)_$$".log

# Create log files
touch ${LOG_FILE}
printf "\033[1;96m%s\n" "--------------------- GitLab Backup Script --------------------" | tee -a "${LOG_FILE}"
printf "\033[1;96m1. %-30s : $(date +%Y-%m-%d)__$(date +%H:%M:%S)\n" "Start Time for Gitlab metadata backup activity" | tee -a "${LOG_FILE}"


# gitlab backup create
echo "Get ready for gitlab backup metadata (it will take 10-15 mins)"
gitlab-backup create force=yes


# Get the most recent file and assign it to most RECENT file.
cd ${METADATA_LOCAL_PATH};
RECENT=$(ls -Art | tail -n 1);
echo "${RECENT} , this is the most recent file"
Printf "\033[1;96m2. %-30s : ${RECENT}\n" "GitLab metadata file name" | tee -a "${LOG_FILE}"
sleep 3s

printf "\033[1;96m3. %-30s : ${RECENT}\n" "Backing activity done" | tee -a "${LOG_FILE}"
printf "\033[1;96m4. %-30s : $(date +%Y-%m-%d)__$(date +%H.%M.%S)\n" "End Time for Gitlab metadata backup activity" | tee -a "${LOG_FILE}"


# Sent secrect files to backup gitlab via rsync.
echo ">> >> >> Sending GitLab secrect files to gitlab_backup server >> >> >>"
rsync -av ${CORE_DATA_LOCAL_PATH}/gitlab* ${USER}@${REMOTE_HOST}:${CORE_DATA_REMOTE_PATH};
echo -e "GitLab secrect files are sent. \nPlease wait 3 sec"
sleep 3s


# Sent backup files to backup gitlab via rsync.

echo ">> >> >> Copying GitLab Metadata file to gitlab_backup server >> >> >>"
printf "\033[1;96m5. %-30s : $(date +%Y-%m-%d)__$(date +%H:%M:%S)\n" "Start Time for sent metadata file to remote end" | tee -a "${LOG_FILE}"

rsync -av ${METADATA_LOCAL_PATH}${RECENT} ${USER}@${REMOTE_HOST}:${METADATA_REMOTE_PATH}${RECENT};
echo -e "GitLab metadata file is sent. \nPlease wait 3 sec"
sleep 3s

printf "\033[1;96m6. %-30s : ${RECENT}\n" "Transfer metadata" | tee -a "${LOG_FILE}"
printf "\033[1;96m7. %-30s : $(date +%Y-%m-%d)__$(date +%H.%M.%S)\n" "End Time for sent metadata file to remote end" | tee -a "${LOG_FILE}"


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


