#!/bin/bash

# Log file
LOG_FILE="system_monitor.log"

# Interval between updates (in seconds)
INTERVAL=5

echo "Monitoring system resources... (Press Ctrl+C to stop)"
echo "Timestamp                | CPU (%) | Memory (%) | Disk Space Used (%)" | tee -a "$LOG_FILE"

while true; do
    # Get timestamp
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    # Get CPU usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

    # Get Memory usage
    MEM_USAGE=$(free | awk '/Mem/ {printf "%.2f", $3/$2 * 100}')

    # Get Disk usage
    DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

    # Print and log data
    echo "$TIMESTAMP | $CPU_USAGE%  | $MEM_USAGE%   | $DISK_USAGE%" | tee -a "$LOG_FILE"

    # Wait for the next update
    sleep $INTERVAL
done
