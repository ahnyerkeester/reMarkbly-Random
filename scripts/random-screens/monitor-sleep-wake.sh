#!/bin/sh
#
# monitor-sleep-wake.sh
#
# Monitors /sys/power/wakeup_count for changes to detect when the
# reMarkable wakes from sleep, then calls set-random-sleep.sh to
# update the sleep screen image.
#
# Runs continuously with a 1-second check interval.

SLEEP_SCRIPT="/usr/share/remarkable/scripts/set-random-sleep.sh"
LAST_WAKEUP=$(cat /sys/power/wakeup_count 2>/dev/null || echo "0")

while true; do
    CURRENT_WAKEUP=$(cat /sys/power/wakeup_count 2>/dev/null || echo "0")

    if [ "$CURRENT_WAKEUP" != "$LAST_WAKEUP" ]; then
        LAST_WAKEUP="$CURRENT_WAKEUP"
        sleep 2
        $SLEEP_SCRIPT
    fi
    sleep 1
done
