#!/bin/bash
#
# Sends a HUP signal upon display configuration is changed to 
# do_change script.
#

# shared config and functions
source "${0%/*}/common.sh"

LOG_TAG_SUFFIX=".signal_change"

# parse command line
CHANGE_DEBUG=0
while getopts d OPTION; do
    case "$OPTION" in
        d) CHANGE_DEBUG=1;;
        *) error "Usage: $0 [−d]\n" 1
    esac
done

# better wait a small moment so changes are already available
sleep 1

UDEV_SH_PID=$(ps -eo comm,pid | grep '[d]o_change.sh' | sed 's/[[:space:]]\+/ /g' | cut -d\  -f 2)
SLEEP_PID=$(ps -eo comm,pid,ppid | awk -v "ppid=$UDEV_SH_PID" ' $3 == ppid && $1 == "sleep" {print $2}')

[ "$CHANGE_DEBUG" = 1 ] && 
    log "Sending HUP -> do_change.sh: $UDEV_SH_PID sleep: $SLEEP_PID" "$LOG_DEBUG" "${LOG_TAG}${LOG_TAG_SUFFIX}"

LOG_KILL=$(kill -HUP "$UDEV_SH_PID" "$SLEEP_PID" 2>&1)
[ $? -ne 0 ] && error "$LOG_KILL" 2
