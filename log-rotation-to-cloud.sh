#!/bin/bash

# Configuration: Define log paths and retention days
declare -A LOG_PATHS
LOG_PATHS["nginx"]="/var/log/nginx"
LOG_PATHS["mysql"]="/var/log/mysql"
LOG_PATHS["myapp"]="/var/log/myapp"

RETENTION_DAYS=7 # Number of days to keep old logs
LOG_ARCHIVE_BASE="/var/log/log_archives"
MASTER_LOG_FILE="$LOG_ARCHIVE_BASE/log_rotation.log"

# AWS S3 Configuration
S3_BUCKET="s3://your-bucket-name/logs"
AWS_CLI_PATH="/usr/bin/aws" # Change if your AWS CLI is installed elsewhere

# Ensure archive directory exists
mkdir -p "$LOG_ARCHIVE_BASE"

# Function to log messages
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$MASTER_LOG_FILE"
}

log_message "Starting multi-application log rotation and S3 upload..."

# Loop through each application log path
for APP in "${!LOG_PATHS[@]}"; do
    LOG_DIR=${LOG_PATHS[$APP]}
    ARCHIVE_DIR="$LOG_ARCHIVE_BASE/$APP"

    # Ensure archive directory exists for each application
    mkdir -p "$ARCHIVE_DIR"

    log_message "Processing logs for $APP in $LOG_DIR..."

    # Find and compress logs older than 1 day
    find "$LOG_DIR" -type f -name "*.log" -mtime +1 -exec gzip {} \;
    log_message "Old logs compressed for $APP."

    # Move compressed logs to archive directory
    find "$LOG_DIR" -type f -name "*.gz" -exec mv {} "$ARCHIVE_DIR/" \;
    log_message "Compressed logs moved to archive for $APP."

    # Upload logs to S3
    log_message "Uploading logs for $APP to S3..."
    $AWS_CLI_PATH s3 cp "$ARCHIVE_DIR/" "$S3_BUCKET/$APP/" --recursive --storage-class STANDARD_IA
    log_message "Logs for $APP uploaded to S3 successfully."

    # Delete logs older than retention period
    find "$ARCHIVE_DIR" -type f -name "*.gz" -mtime +$RETENTION_DAYS -exec rm {} \;
    log_message "Logs older than $RETENTION_DAYS days deleted for $APP."
done

log_message "Multi-application log rotation and S3 upload completed successfully!"
