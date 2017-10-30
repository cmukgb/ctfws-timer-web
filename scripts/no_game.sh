#!/bin/bash

# Sets $password_file
source get_password.sh

if [ "$#" -ne 0 ]
then
  echo "Usage: $0"
  exit 1
else
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat "$password_file") -q 1 -r -t ctfws/game/config -m none
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat "$password_file") -q 1 -r -t ctfws/game/flags -m "0 0"
  echo "Set to no game"
fi

