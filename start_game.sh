#!/bin/bash

if [ ! -f "password.txt" ]
then
  echo "File password.txt must exist to run this command"
  exit 1
fi

if [ "$#" -ne 2 ]
then
  echo Usage: "$0" num_flags game_num
  exit 1
else
	m="`date +%s` 900 4 900 ""$1"" ""$2"
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat password.txt) -q 1 -r -t ctfws/game/config -m "$m"
fi

