#!/bin/bash

# Check if process name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

PROCESS_NAME=$1

# List matching processes
echo "Searching for processes matching: $PROCESS_NAME"
ps aux | grep "$PROCESS_NAME" | grep -v "grep" | grep -v "$0"

# Ask the user for the Process ID (PID) to kill
echo "Enter the PID of the process to kill (or press Enter to cancel):"
read PID

# Validate PID
if [[ ! $PID =~ ^[0-9]+$ ]]; then
    echo "Invalid PID. Exiting."
    exit 1
fi

# Kill the selected process
kill -9 "$PID" && echo "Process $PID killed successfully!" || echo "Failed to kill process $PID."
