#!/bin/sh

# Backup tao_production db
mysqldump -utao -pKiBr11EY23nj --sock=/tmp/mysql.sock tao_production | gzip > /home/app/backups/tao_`date +\%Y-\%m-\%d-\%T`.sql.gz

# Backup tao_1s_production db
mysqldump -utao_1s -pcJvauLgtd0ul --sock=/tmp/mysql.sock tao_1s_production | gzip > /home/app/backups/tao_1s_`date +\%Y-\%m-\%d-\%T`.sql.gz
