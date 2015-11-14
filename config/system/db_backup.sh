#!/bin/sh

# Backup tao_production db
mysqldump -uryeboy -pESqOeI22MWrk ryeboy_production | gzip > /home/app/backups/ryeboy_`date +\%Y-\%m-\%d`.sql.gz

# Backup tao_1s_production db
mysqldump -ulotus -pQenzw6YwyLOq lotus_production | gzip > /home/app/backups/lotus_`date +\%Y-\%m-\%d`.sql.gz
