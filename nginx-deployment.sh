#!/bin/bash

# Define variables
NGINX_STATUS=$(systemctl is-active nginx)
LOG_FILE="nginx_deployment.log"

# Function to log messages
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    log_message "Please run as root or use sudo!"
    exit 1
fi

# Install Nginx if not installed
if ! command -v nginx &>/dev/null; then
    log_message "Nginx is not installed. Installing..."
    apt update && apt install -y nginx
    log_message "Nginx installation completed."
else
    log_message "Nginx is already installed."
fi
# Start and enable Nginx
if [[ "$NGINX_STATUS" != "active" ]]; then
    log_message "Starting Nginx service..."
    systemctl start nginx
    systemctl enable nginx
    log_message "Nginx service started and enabled."
else
    log_message "Nginx is already running."
fi

# Health check - Verify if Nginx is running
if systemctl is-active --quiet nginx; then
    log_message "Nginx is running successfully!"
else
    log_message "Nginx failed to start!"
    exit 1
fi

# Test Nginx response
log_message "Testing Nginx default page..."
if curl -Is http://localhost | head -n 1 | grep "200 OK"; then
    log_message "Nginx is serving pages correctly."
else
    log_message "Nginx is NOT serving pages properly! Check configurations."
    exit 1
fi

log_message "Nginx deployment and health check completed successfully!"
