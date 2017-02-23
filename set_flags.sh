#!/bin/bash

if [ ! -f "password.txt" ]
then
  echo "File password.txt must exist to run this command"
  exit 1
fi

if [ "$#" -ne 1 ]
then
  echo Usage: "$0" flags
  echo "flags is either ? or two numbers in quotes separated by a space"
  echo "the order is red_flags_captured yellow_flags_captured"
  echo 'e.g. "?" or "1 1"'
  exit 1
else
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat password.txt) -q 1 -r -t ctfws/game/flags -m "$1"
fi

