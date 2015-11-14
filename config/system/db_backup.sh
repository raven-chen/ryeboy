#!/bin/sh

# Backup ryeboy_production db
mysqldump -uryeboy -pESqOeI22MWrk ryeboy_production | gzip > /home/app/backups/ryeboy_`date +\%Y-\%m-\%d`.sql.gz

# Backup lotus_production db
mysqldump -ulotus -pQenzw6YwyLOq lotus_production | gzip > /home/app/backups/lotus_`date +\%Y-\%m-\%d`.sql.gz

# Keep recent 1 month backups
find /home/app/backups/ -type f -ctime +30 -delete
