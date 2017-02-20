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
  mosquitto_pub -h nwf1.xen.prgmr.com -u ctfwsmaster -P $(cat password.txt) -q 1 -r -t ctfws/game/config -m none
fi

