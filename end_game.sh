#!/bin/bash

if [ ! -f "password.txt" ]
then
  echo "File password.txt must exist to run this command"
  exit 1
fi

if [ "$#" -ne 0 ]
then
  echo Usage: "$0"
  exit 1
else
	m="`date +%s`"
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat password.txt) -q 1 -r -t ctfws/game/endtime -m "$m"
fi

