#!/bin/bash

# Configuration
BACKUP_DIR="/opt/backups"                               # Directory where backups will be stored
SOURCES=("/etc/nginx" "/var/www/html" "/var/lib/mysql") # Directories to back up
RETENTION_DAYS=7                                        # Number of days to keep old backups
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# AWS S3 Configuration
S3_BUCKET="s3://your-bucket-name/backups"
AWS_CLI_PATH="/usr/bin/aws" # Adjust if AWS CLI is installed elsewhere

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Function to log messages
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

log_message "Starting backup process..."

# Create a compressed backup
tar -czf "$BACKUP_FILE" "${SOURCES[@]}"
log_message "Backup created at $BACKUP_FILE"

# Upload to S3
log_message "Uploading backup to S3..."
$AWS_CLI_PATH s3 cp "$BACKUP_FILE" "$S3_BUCKET/"
log_message "Backup uploaded to S3 successfully."
