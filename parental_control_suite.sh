#!/bin/bash

# Call & SMS Logger

LOG_FILE="logs/call_sms_log.txt"
mkdir -p logs

echo "📲 Starting Call & SMS Logger..."

# Simulating log entries (replace with real capture commands if needed)
while true; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Call from: +1234567890" >> "$LOG_FILE"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - SMS from: +1234567890 | Message: 'Where are you?'" >> "$LOG_FILE"
    sleep 10

done
