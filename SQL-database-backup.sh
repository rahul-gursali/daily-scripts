# script used for creating a backup of a MySQL database

#!/bin/bash
mysqldump -u root -p mydb >/backup/mydb_$(date +%F).sql
