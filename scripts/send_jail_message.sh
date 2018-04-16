#!/bin/bash

# Get this script file. Since readlink -f doesn't work on every system, just
# return $0 if it fails. We don't support linking the script on those systems.
script_file=$(readlink -f "$0" 2> /dev/null || echo "$0")

# Sets $password_file
source $(dirname "$script_file")/get_password.sh

if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]
then
  echo "Usage: $0 message [timestamp]"
  exit 1
else
  if [ "$#" -eq 2 ]
  then
    d="$2"
  else
    d=$(date +%s)
  fi
  m="$d $1"
  mosquitto_pub -u ctfwsmaster -P $(cat "$password_file") -q 1 -r -t ctfws/game/message/jail -m "$m" &&
  echo "Sent jail message at $d"
fi
