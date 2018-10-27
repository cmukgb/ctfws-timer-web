#!/bin/bash

# Get this script file. Since readlink -f doesn't work on every system, just
# return $0 if it fails. We don't support linking the script on those systems.
script_file=$(readlink -f "$0" 2> /dev/null || echo "$0")

# Sets $password_file
source $(dirname "$script_file")/mqtt_config.sh

if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]
then
  echo "Usage: $0 flags [timestamp]"
  echo "flags is either ? or two numbers in quotes separated by a space"
  echo "the order is red_flags_captured yellow_flags_captured"
  echo 'e.g. "?" or "1 1"'
  exit 1
else
  if [ "$#" -eq 2 ]
  then
    d="$2"
  else
    d=$(date +%s)
  fi
  m="$d $1"
  mosquitto_pub -h ${MQTT_HOST:-localhost} -u ctfwsmaster -P $(cat "$password_file") -q 1 -r -t ctfws/game/flags -m "$m" &&
  echo "Set flags to $1 at $d"
fi
