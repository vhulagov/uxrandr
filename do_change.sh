#!/bin/bash
#
# Runs in a xsession and changes display configuration upon 
# recieving a HUP signal. Script sleeps (for 1d in each cycle
# while waiting for signal to come).
#

source "${0%/*}/common.sh"

#TK#140505#should not be necessary
#export DISPLAY=:0.0
#export XAUTHORITY=/home/kadleto2/.Xauthority
#CONFDIR="${0%/*}/conf"

##
# Detect all displays
function detectDisplays {
    xrandr | grep '^[A-Z]' | tail -n+2 | cut -d\  -f1 | sort -u
}

##
# Detect connected displays
function connectedDisplays {
    xrandr | grep '[[:space:]]connected' | cut -d\  -f1 | sort -u
}

##
# Detect enabled displays
function enabledDisplays {
    #xrandr --current | awk ' /^(DP|HDMI|LVDS|VGA)/ { OUTPUT = $1; } /^[[:space:]]+[0-9x]+.*\+/ { print OUTPUT } ' | sort -u
    xrandr --verbose | awk '/^(DP|HDMI|LVDS|VGA)/ { output = $1 } /CRTC:/ { print output; }'
}

function availableConfigurations {
    local CONFDIR
    for CONFDIR in "$CONF_USER" "$CONF_SYSTEM"; do
        [ -n "$1" -a -f "$CONFDIR/$1" ] && echo "$CONFDIR/$1"
    done
    [ -z "$2" ] && return
    local config="$1"
    shift 1
    local displays="$@"
    shift 1
    for display in $displays; do
        availableConfigurations "$config${display}_" "$@"
    done
}

function selectConfiguration {
    local config=$(availableConfigurations '' $(connectedDisplays) | head -n1)
    if [ -f "$config" ]; then
        applyConfiguration "$config"
    fi
}

function currentConfiguration {
    xrandr --current | awk ' /^(DP|HDMI|LVDS|VGA)/ { OUTPUT = $1; PANNING=$3 } /\*\+/ { print OUTPUT ";" $1 ";--panning " PANNING  } ' | sort -u
}

function applyConfiguration {
    info "$1"
    # vypnout vsechno
    for display in $(enabledDisplays); do
        xrandr --output $display --off
    done
    # zpracovat config
    local line
    local cmd=''
    while read line; do
        local output=$(echo "$line" | cut -d\; -f1)
        [ -z "$output" ] && echo "FIXME this is an fatal error!"
        local mode=$(echo "$line" | cut -d\; -f2)
        [ -z "$mode" ] && mode="--auto" || mode="--mode $mode"
        local position=$(echo "$line" | cut -d\; -f3)
        xrandr --output "$output" $mode $position
    done < <(tail -n+2 "$1")
    xrandr --dpi 96
}

function primary {
    xrandr --output "$1" --primary
}

trap selectConfiguration SIGHUP

while true; do
    sleep 1d 1>/dev/null 2>&1
done 
