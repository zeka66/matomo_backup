#!/bin/sh

### Variables ###

DB_BACKUP_PATH='/backup/dbmatomo'
DB_USER='root'
DB_PASS='abc'
DB_NAME='matomo'
DB_PORT='3306'
DATE=$(date '+%d.%m.%Y_%T')
BUCKET_NAME='devops-backup-storage'

### Matomo backup and archive ###

mkdir -p ${DB_BACKUP_PATH}
echo "Backup started for database - ${DB_NAME}"

sudo mysqldump\
        -P${DB_PORT}\
      	-u${DB_USER}\
       	-p${DB_PASS}\
      	--no-tablespaces ${DB_NAME} | gzip -c >${DB_BACKUP_PATH}/${DATE}.gz

echo "${DB_NAME} DB backup completed"

### Copy backup to S3 bucket ###

aws s3 mv ../backup/dbmatomo/*.gz s3://$BUCKET_NAME/ --quiet --storage-class STANDARD
