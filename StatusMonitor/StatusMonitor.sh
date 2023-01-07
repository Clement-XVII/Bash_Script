#!/bin/bash

INTERVAL=300 # Default interval is 5 minutes

# Read host list from hosts.lst
HOSTS=()
while read -r line; do
HOSTS+=("$line")
done < hosts.lst

# Continuously ping hosts at the specified interval
while true; do
# Clear terminal
clear

# Print table header
printf "%-20s %-20s %s\n" "Host" "Name" "Status"
printf "%-20s %-20s %s\n" "----" "----" "------"

DOWN_COUNT=0
for HOST in "${HOSTS[@]}"; do
    # Check if host is responsive
    if ping -c 1 "$HOST" > /dev/null; then
        # Host is responsive, print status and name
        NAME=$(nslookup "$HOST" | grep "name = " | awk '{print $NF}')
        printf "%-20s %-20s %s\n" "$HOST" "$NAME" "[$(tput setaf 2)UP$(tput sgr0)]"
    else
        # Host is not responsive, print status and name
        NAME=$(nslookup "$HOST" | grep "name = " | awk '{print $NF}')
        printf "%-20s %-20s %s\n" "$HOST" "$NAME" "[$(tput setaf 1)DOWN$(tput sgr0)]"
        DOWN_COUNT=$((DOWN_COUNT + 1))
    fi
done

# Print an empty line for improved readability
echo ""

# Print a summary of the host status
#echo "Summary @ $(date +%T): $(tput setaf 3)$DOWN_COUNT$(tput sgr0) out of ${#HOSTS[@]} hosts are DOWN"
echo "Summary @ $(date +%T): $(tput setaf 3)$DOWN_COUNT$(tput sgr0) out of ${#HOSTS[@]} hosts are $(tput setaf 1)DOWN$(tput sgr0)"
# Sleep for the specified interval before pinging again
SECONDS_REMAINING=$INTERVAL
while [ "$SECONDS_REMAINING" -gt 0 ]; do
    printf "\rRefreshing in %02d seconds... " "$SECONDS_REMAINING"
    sleep 1
    SECONDS_REMAINING=$((SECONDS_REMAINING - 1))
done
echo ""
done
