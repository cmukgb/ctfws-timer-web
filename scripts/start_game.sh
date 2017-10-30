#!/bin/bash

# Sets $password_file
source get_password.sh

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
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat $password_file) -q 1 -r -t ctfws/game/config -m "$m"
  echo "Started game at $d"
fi

