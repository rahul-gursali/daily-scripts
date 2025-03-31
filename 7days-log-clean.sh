#!/bin/bash
find /var/log -type f -name "*.log" -mtime +7 -exec rm -f {} \;

## this is to clean log files more than 7 days ##
