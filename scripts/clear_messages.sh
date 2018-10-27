#!/bin/bash

# Get this script file. Since readlink -f doesn't work on every system, just
# return $0 if it fails. We don't support linking the script on those systems.
script_file=$(readlink -f "$0" 2> /dev/null || echo "$0")

# Sets $password_file
source $(dirname "$script_file")/mqtt_config.sh

if [ "$#" -ne 0 ] && [ "$#" -ne 1 ]
then
  echo "Usage: $0 [timestamp]"
  exit 1
else
  if [ "$#" -eq 1 ]
  then
    # Check for help arguments since running with no args won't show usage
    if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]
    then
      echo "Usage: $0 [timestamp]"
      echo "       timestamp defaults to now"
      echo "Hide all messages sent before timestamp"
      exit 0
    else
      d="$1"
    fi
  else
    d=$(date +%s)
  fi
  mosquitto_pub -h ${MQTT_HOST:-localhost} -u ctfwsmaster -P $(cat "$password_file") -q 1 -r -t ctfws/game/messagereset -m "$d" &&
  echo "Cleared messages before $d"
fi
