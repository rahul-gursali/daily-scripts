#!/bin/bash
SERVERS=("192.168.1.1" "192.168.1.2")
for SERVER in "${SERVERS[@]}"; do
    ping -c 2 $SERVER >/dev/null && echo "$SERVER is up" || echo "$SERVER is down"
done
