#!/bin/bash

# Parental Control Suite Setup

# Ensure logs folder exists
mkdir -p logs

# ================================
# Call & SMS Logger
# ================================
LOG_FILE="logs/call_sms_log.txt"
echo "📲 Call & SMS Logger started..." > "$LOG_FILE"

# Simulate call/SMS log (placeholder)
while true; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Call from: +1234567890" >> "$LOG_FILE"
    sleep 10
done &

# ================================
# Restricted App Alerts
# ================================
RESTRICTED_APPS=("TikTok" "Instagram" "Snapchat")
ALERT_LOG="logs/restricted_app_alerts.txt"
echo "🚨 Monitoring for Restricted Apps..." > "$ALERT_LOG"

while true; do
    for app in "${RESTRICTED_APPS[@]}"; do
        if pgrep -f "$app" > /dev/null; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - ALERT: $app launched!" >> "$ALERT_LOG"
        fi
    done
    sleep 5

done &

# ================================
# Geofence Alerts
# ================================
SAFE_LAT=48.8566
SAFE_LON=2.3522
GEOFENCE_RADIUS=0.01
GEO_LOG="logs/geofence_alerts.txt"
echo "📍 Starting Geofence Monitor..." > "$GEO_LOG"

while true; do
    CURRENT_LAT=$(echo "48.8566 + $(awk -v min=-0.005 -v max=0.005 'BEGIN{srand(); print min+rand()*(max-min)}')" | bc)
    CURRENT_LON=$(echo "2.3522 + $(awk -v min=-0.005 -v max=0.005 'BEGIN{srand(); print min+rand()*(max-min)}')" | bc)

    DISTANCE=$(echo "sqrt(($CURRENT_LAT - $SAFE_LAT)^2 + ($CURRENT_LON - $SAFE_LON)^2)" | bc)
    if (( $(echo "$DISTANCE > $GEOFENCE_RADIUS" | bc -l) )); then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ALERT: Child left safe zone!" >> "$GEO_LOG"
    fi
    sleep 10

done &

# ================================
# Battery Status Alerts
# ================================
BATTERY_LOG="logs/battery_alerts.txt"
BATTERY_THRESHOLD=20
echo "🔋 Starting Battery Monitor..." > "$BATTERY_LOG"

while true; do
    BATTERY_LEVEL=$(shuf -i 10-100 -n 1)
    if (( BATTERY_LEVEL <= BATTERY_THRESHOLD )); then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ALERT: Battery low ($BATTERY_LEVEL%)!" >> "$BATTERY_LOG"
    fi
    sleep 10

done &

# ================================
# App Blocker
# ================================
BLOCK_LOG="logs/app_blocker_log.txt"
echo "⛔ Starting App Blocker..." > "$BLOCK_LOG"

while true; do
    for app in "${RESTRICTED_APPS[@]}"; do
        if pgrep -f "$app" > /dev/null; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Blocked: $app forcibly closed!" >> "$BLOCK_LOG"
            killall "$app"
        fi
    done
    sleep 5

done &

# ================================
# Suite Startup Complete
# ================================
echo "✅ Parental Control Suite running in the background!"
