#!/bin/bash

# Get this script file. Since readlink -f doesn't work on every system, just
# return $0 if it fails. We don't support linking the script on those systems.
script_file=$(readlink -f "$0" 2> /dev/null || echo "$0")

# Sets $password_file
source $(dirname "$script_file")/get_password.sh

if [ "$#" -ne 2 ] && [ "$#" -ne 3 ]
then
  echo "Usage: $0 num_flags game_num [timestamp]"
  exit 1
else
  if [ "$#" -eq 3 ]
  then
    d="$3"
  else
    d=$(date +%s)
  fi
  m="$d 900 4 900 $1 $2"
  mosquitto_pub -u ctfwsmaster -P $(cat $password_file) -q 1 -r -t ctfws/game/config -m "$m" &&
  echo "Started game $2 with $1 flags at $d"
fi
