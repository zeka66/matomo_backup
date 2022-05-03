#!/bin/sh

### Variables ###

db_backup_path='/backup/matomodb/'
db_user='root'
db_pass="abc"
db_name='matomo'
db_port='3306'
date=$(date '+%d.%m.%Y_%T')
rt='0' #Retention period

### Matomo backup and archive ###

mkdir -p ${db_backup_path}
echo "Backup started for database - ${db_name}"

sudo mysqldump\
        -P${db_port}\
        -u${db_user}\
        -p${db_pass}\
        --no-tablespaces ${db_name} | gzip -c >${db_backup_path}/${date}.gz

echo "$db_name DB backup completed"

### Copy backup to S3 bucket ###

#aws s3 sync /home/ubuntu/matomodb_backup/ s3://devops-backup-storage/matomo_backup/ --delete --profile holmtestprofile

ava
# Remove backups more than 30 days oldvfsv
find $db_backup_path -name "*.gz" -type f -mtime +$rt -delete

exit 0

#!/usr/bin/env bash
# This script is managed with ansible

cd /home/ubuntu

# Do the backup, configuration is in .grafana-backup.json
grafana-backup save

# Remove backups more than 30 days old
find /home/ubuntu/grafana_backup/* -mtime +30 -exec rm {} \;

# sync backup folder to AWS
aws s3 sync /home/ubuntu/grafana_backup/ s3://devops-backup-storage/grafana_backup/ --include *.tar.gz --exclude dashboard_versions --delete

exit 0
