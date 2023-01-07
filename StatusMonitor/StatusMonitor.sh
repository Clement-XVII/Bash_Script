#!/bin/bash

# Function to read the list of hosts from the file
read_hosts() {
  HOSTS=()
  NAMES=()
  while read -r line; do
    HOSTS+=("$(echo "$line" | cut -d ',' -f1)")
    NAMES+=("$(echo "$line" | cut -d ',' -f2)")
  done < "$HOST_FILE"
}

print_table() {
   printf "%-20s %-20s %-20s %-10s %s\n" "IP Address" "DNS" "Name" "Latency" "Status"
  printf "%-20s %-20s %-20s %-10s %s\n" "----------" "---" "----" "-------" "------"
}

# Function to ping a host and return the result
ping_host() {
  HOST=$1
  PING_RESULT=$(ping -q -c 1 -w 1 "$HOST")
  if [ $? -eq 0 ]; then
    DNS=$(nslookup "$HOST" | grep "name = " | awk '{print $NF}')
    LATENCY=$(echo "$PING_RESULT" | tail -1 | awk '{print $4}' | cut -d '/' -f 2) &> /dev/null
    printf "%-20s %-20s %-20s %-10s %s\n" "$HOST" "$DNS" "$NAME" "$LATENCY ms" "[$(tput setaf 2) UP $(tput sgr0)]"
  else
    DNS=$(nslookup "$HOST" | grep "name = " | awk '{print $NF}')
    printf "%-20s %-20s %-20s %-10s %s\n" "$HOST" "$DNS" "$NAME" "-" "[$(tput setaf 1)DOWN$(tput sgr0)]"
    DOWN_COUNT=$((DOWN_COUNT + 1))
  fi
}

# Function to print the status of all hosts
print_status() {
  DOWN_COUNT=0
  for i in "${!HOSTS[@]}"; do
    HOST=${HOSTS[$i]}
    NAME=${NAMES[$i]}
    ping_host "$HOST"
  done
}

# Function to print the summary of the host status
print_summary() {
  echo ""
  if [ "$DOWN_COUNT" == 0 ]; then
    echo "Summary @ $current_time: All hosts are $(tput setaf 2)UP$(tput sgr0)"
  else
    echo "Summary @ $current_time: $DOWN_COUNT out of ${#HOSTS[@]} hosts are $(tput setaf 1)DOWN$(tput sgr0)"
  fi
  SECONDS_REMAINING=$INTERVAL
 
until [ "$SECONDS_REMAINING" == 0 ]; do
    printf "\rRefreshing in %02d seconds... " "$SECONDS_REMAINING"
    sleep 1
    SECONDS_REMAINING=$((SECONDS_REMAINING - 1))
  done
}

# Main script
INTERVAL=15 # Default interval is 15 minutes
HOST_FILE=hosts.lst # Default host file is hosts.lst

# Parse options
while getopts ":f:" opt; do
  case $opt in
    f)
      HOST_FILE=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Read host list from specified file
read_hosts

# Continuously ping hosts at the specified interval
while true; do

  # Clear terminal
  clear
  print_table
  print_status
  print_summary
  echo ""
done
