#!/bin/bash

# If script was symlinked, allow password.txt to be at target of link
password_file=""
if [ -f "password.txt" ]
then
  password_file="password.txt"
else
  if [ -h "$0" ] # Test for symlink
  then
    password_dir=$(dirname $(readlink -f "$0"))
    password_file="$password_dir"/password.txt
  fi
fi
if [ -z "$password_file" ]
then
  echo "File password.txt must exist to run this command"
  exit 1
fi

if [ "$#" -ne 1 ]
then
  echo Usage: "$0" message
  exit 1
else
  m="$(date +%s) ""$1"
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat $password_file) -q 1 -r -t ctfws/game/message/jail -m "$m"
fi

