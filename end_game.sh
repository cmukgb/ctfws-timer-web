#!/bin/bash

# If script was symlinked, allow password.txt to be at target of link
password_file=""
if [ -f "password.txt" ]
then
  password_file="password.txt"
else
  if [ -h "$0" ] # Test for symlink
  then
    password_dir=$(dirname $(readlink "$0"))
    password_file="$password_dir"/password.txt
  fi
fi
if [ -z "$password_file" ]
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
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat $password_file) -q 1 -r -t ctfws/game/endtime -m "$m"
fi

