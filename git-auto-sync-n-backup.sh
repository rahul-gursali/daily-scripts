#!/bin/bash

# Configuration
REPO_DIR="/path/to/your/repository" # Change to your Git repository path
BRANCH="main"                       # Change to the branch you want to sync
BACKUP_DIR="/backup/git"            # Change to your backup directory
LOG_FILE="/var/log/git_backup.log"
ALERT_EMAIL="admin@example.com" # Change to your admin email

# Function to log messages
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Function to send email alerts (optional)
send_alert() {
    local subject=$1
    local message=$2
    echo -e "$message" | mail -s "$subject" "$ALERT_EMAIL"
}

log_message "Starting Git backup and synchronization..."

# Navigate to the repository
cd "$REPO_DIR" || {
    log_message "❌ Repository directory not found! Exiting."
    exit 1
}

# Fetch the latest updates
log_message "🔹 Fetching latest changes..."
git fetch origin "$BRANCH"
if [ $? -ne 0 ]; then
    log_message "❌ Failed to fetch latest changes!"
    send_alert "Git Backup Error" "Failed to fetch latest changes from Git."
    exit 1
fi

# Create a backup before pulling changes
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="git_backup_$TIMESTAMP.tar.gz"
log_message "🔹 Creating a backup of the current state..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$REPO_DIR"
log_message "✅ Backup created: $BACKUP_DIR/$BACKUP_NAME"

# Pull the latest changes
log_message "🔹 Pulling latest changes from $BRANCH..."
git pull origin "$BRANCH"
if [ $? -ne 0 ]; then
    log_message "❌ Failed to pull latest changes!"
    send_alert "Git Backup Error" "Git pull failed for repository $REPO_DIR."
    exit 1
fi

# Auto-add, commit, and push new changes (optional)
log_message "🔹 Checking for uncommitted changes..."
if [[ -n $(git status --porcelain) ]]; then
    git add .
    COMMIT_MSG="Auto backup & sync on $(date)"
    git commit -m "$COMMIT_MSG"
    git push origin "$BRANCH"
    log_message "✅ Changes committed and pushed successfully."
else
    log_message "✅ No new changes to commit."
fi

log_message "✅ Git backup and synchronization completed successfully!"
send_alert "Git Backup Success" "Git backup and sync completed successfully."
