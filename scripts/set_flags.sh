#!/bin/bash

# Get this script file. Since readlink -f doesn't work on every system, just
# return $0 if it fails. We don't support linking the script on those systems.
script_file=$(readlink -f "$0" 2> /dev/null || echo "$0")

# Sets $password_file
source $(dirname "$script_file")/get_password.sh

if [ "$#" -ne 1 ]
then
  echo "Usage: $0 flags"
  echo "flags is either ? or two numbers in quotes separated by a space"
  echo "the order is red_flags_captured yellow_flags_captured"
  echo 'e.g. "?" or "1 1"'
  exit 1
else
  m="$1"
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat "$password_file") -q 1 -r -t ctfws/game/flags -m "$m"
  echo "Set flags to $m"
fi

