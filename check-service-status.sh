#!/bin/bash
SERVICE="nginx"
if ! systemctl is-active --quiet $SERVICE; then
    echo "$SERVICE is down, restarting..."
    systemctl restart $SERVICE
fi

### this is to check if service is running or not, if not then restart the "nginx" service
