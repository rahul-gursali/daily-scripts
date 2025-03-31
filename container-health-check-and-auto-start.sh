#!/bin/bash

# Configuration
LOG_FILE="/var/log/docker_health.log"
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

log_message "Starting Docker container health check..."

# Get a list of all running Docker containers
CONTAINERS=$(docker ps --format "{{.ID}} {{.Names}}")

if [ -z "$CONTAINERS" ]; then
    log_message "No running containers found."
    exit 0
fi

# Loop through each container and check its health
while read -r CONTAINER_ID CONTAINER_NAME; do
    HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' "$CONTAINER_ID" 2>/dev/null)

    if [ "$HEALTH_STATUS" == "unhealthy" ]; then
        log_message "Container '$CONTAINER_NAME' ($CONTAINER_ID) is unhealthy! Restarting..."
        docker restart "$CONTAINER_ID"
        log_message "Container '$CONTAINER_NAME' restarted successfully."
        send_alert "Docker Container Restarted" "Container '$CONTAINER_NAME' was unhealthy and has been restarted."
    else
        log_message "Container '$CONTAINER_NAME' is healthy."
    fi
done <<<"$CONTAINERS"

log_message "Docker container health check completed."
