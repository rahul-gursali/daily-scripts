#!/bin/bash

# Configuration
LOG_DIR="/var/log/myapp"              # Change this to your log directory
RETENTION_DAYS=7                      # Number of days to keep old logs
LOG_ARCHIVE="/var/log/myapp_archives" # Directory to store compressed logs
LOG_FILE="log_rotation.log"           # Log file for tracking script actions

# Ensure log archive directory exists
mkdir -p "$LOG_ARCHIVE"

# Function to log messages
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_ARCHIVE/$LOG_FILE"
}

log_message "Starting log rotation for $LOG_DIR..."

# Find and compress logs older than 1 day
find "$LOG_DIR" -type f -name "*.log" -mtime +1 -exec gzip {} \;

log_message "Old logs compressed successfully."

# Move compressed logs to archive directory
find "$LOG_DIR" -type f -name "*.gz" -exec mv {} "$LOG_ARCHIVE/" \;

log_message "Compressed logs moved to archive folder: $LOG_ARCHIVE."

# Delete logs older than retention period
find "$LOG_ARCHIVE" -type f -name "*.gz" -mtime +$RETENTION_DAYS -exec rm {} \;

log_message "Logs older than $RETENTION_DAYS days deleted."

log_message "Log rotation and cleanup completed successfully!"
