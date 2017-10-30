#!/bin/bash

# Sets $password_file
source get_password.sh

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

