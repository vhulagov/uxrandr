#!/bin/bash

CONF_USER="$HOME/.uxrandr"
CONF_SYSTEM="${0%/*}/conf"

LOG_CMD="logger"
LOG_FACILITY="local7"
LOG_TAG="uxrandr"
LOG_ERROR="err"
LOG_INFO="info"
LOG_DEBUG="debug"

CONFDIR="${0%/*}/conf"

function log {
    local message="${1:-No message!}"
    local level="${2:-$LOG_DEBUG}"
    local tag="${3:-$LOG_TAG}"
    local facility="${4:-$LOG_FACILITY}"
    if [ -t 1 ] ; then
            echo "$message" >&2
    else
            logger -p "$facility.$level" -t "$tag" "$message"
    fi
}

function debug {
    local code="${2:-1}"
    log "($code) $1" "$LOG_DEBUG" 
}

function info {
    local code="${2:-1}"
    log "($code) $1" "$LOG_INFO" 
}

function error {
    local code="${2:-1}"
    log "($code) $1" "$LOG_ERROR"
    exit "$code"
}

