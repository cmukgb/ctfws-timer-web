#!/bin/bash

# Sets $password_file
source get_password.sh

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
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat "$password_file") -q 1 -r -t ctfws/game/message -m "$m"
  echo "Sent message at $d"
fi

