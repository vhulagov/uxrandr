#!/bin/bash 

source "${0%/*}/common.sh"
CONFDIR="$CONF_USER"

while getopts g OPTION; do
    case "$OPTION" in
        g) CONFDIR="$CONF_SYSTEM";;
        *) printf "Usage: %s: [−g] \n" $0; exit 1;;
    esac
done

[ ! -d "$CONFDIR" ] && { echo "Configuration directory $CONF_SYSTEM does not exists"; exit 2; }
[ ! -w "$CONFDIR" ] && { echo "Configuration directory $CONF_SYSTEM is not writable"; exit 3; }

cd "$CONFDIR"

# traverse all files and make symlinks to configuration
find . -maxdepth 1 -type f | while read FILE; do
    SCREENS=`tail -n+2 "$FILE" | cut -d\; -f1`
    ln -snf "$FILE" $(echo "$SCREENS" | sort -u | tr '\n' '_')
done

cd - 1>/dev/null 2>&1
