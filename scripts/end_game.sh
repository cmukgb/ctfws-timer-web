#!/bin/bash

# Sets $password_file
source get_password.sh

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

