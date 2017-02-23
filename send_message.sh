#!/bin/bash

if [ ! -f "password.txt" ]
then
  echo "File password.txt must exist to run this command"
  exit 1
fi

if [ "$#" -ne 1 ]
then
  echo Usage: "$0" message
  exit 1
else
  m="`date +%s` ""$1"
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat password.txt) -q 1 -r -t ctfws/game/message -m "$m"
fi

