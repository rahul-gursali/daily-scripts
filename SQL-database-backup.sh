#!/bin/bash
mysqldump -u root -p mydb >/backup/mydb_$(date +%F).sql
