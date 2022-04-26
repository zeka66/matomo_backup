#!/bin/sh

### Variables ###

db_backup_path='/backup/matomodb/'
db_user='root'
db_pass='abc'
db_name='matomo'
db_port='3306'
date=$(date '+%d.%m.%Y_%T')

### Matomo backup and archive ###

mkdir -p ${db_backup_path}
echo "Backup started for database - ${db_name}"

sudo mysqldump\
	-P${db_port}\
      	-u${db_user}\
       	-p${db_pass}\
      	--no-tablespaces ${db_name} | gzip -c >${db_backup_path}/${date}.gz

echo "${db_name} DB backup completed"

### Copy backup to S3 bucket ###

aws s3 sync //backup/matomodb/ s3://devops-backup-storage/matomo_backup/ --delete --profile holmtestprofile
