#!/bin/bash

# Get this script file. Since readlink -f doesn't work on every system, just
# return $0 if it fails. We don't support linking the script on those systems.
script_file=$(readlink -f "$0" 2> /dev/null || echo "$0")

# Sets $password_file
source $(dirname "$script_file")/get_password.sh

if [ "$#" -ne 0 ] && [ "$#" -ne 1 ]
then
  echo "Usage: $0 [timestamp]"
  exit 1
else
  if [ "$#" -eq 1 ]
  then
    d="$1"
  else
    d=$(date +%s)
  fi
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat "$password_file") -q 1 -r -t ctfws/game/endtime -m "$d"
  echo "Ended game at $d"
fi

