#!/bin/bash

# putitback.sh - Restoration script after reMarkable system updates
# This script restores the random sleep screen setup after a device update
# wipes /usr/share and /etc/systemd/system directories

# Locate the source scripts relative to this script's location
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_SRC="$SCRIPT_DIR/scripts/random-screens"

# Create the target directory if it doesn't exist
mkdir -p /usr/share/remarkable/scripts

# Copy the main script and set permissions
# set-random-sleep.sh: Selects a random image and sets it as the sleep screen
cp "$SCRIPTS_SRC/set-random-sleep.sh" /usr/share/remarkable/scripts/
chmod 755 /usr/share/remarkable/scripts/set-random-sleep.sh

# Copy the monitor-sleep-wake script and set permissions
# monitor-sleep-wake.sh: Monitors /sys/power/wakeup_count and triggers
# set-random-sleep.sh whenever the device wakes from sleep
cp "$SCRIPTS_SRC/monitor-sleep-wake.sh" /usr/share/remarkable/scripts/
chmod 755 /usr/share/remarkable/scripts/monitor-sleep-wake.sh

# Copy the systemd service file
# monitor-sleep-wake.service: Runs monitor-sleep-wake.sh at boot and
# automatically restarts if it crashes
cp "$SCRIPTS_SRC/monitor-sleep-wake.service" /etc/systemd/system/
chmod 644 /etc/systemd/system/monitor-sleep-wake.service

# Remove the old timer-based approach (if it exists from previous setup)
# This disables the 5-minute timer that was less efficient
systemctl disable --now random-screens.timer 2>/dev/null || true
rm -f /etc/systemd/system/random-screens.timer
rm -f /etc/systemd/system/random-screens.service

# Reload systemd daemon to recognize new service
systemctl daemon-reload

# Enable and start the new monitor service
# This will auto-start on reboot and keep running in background
systemctl enable --now monitor-sleep-wake.service

# Run the script once immediately to set an initial random sleep screen
/usr/share/remarkable/scripts/set-random-sleep.sh

echo "Restoration complete! Random sleep screen monitor is now active."
echo "The device will change the sleep screen image every time it wakes from sleep.",