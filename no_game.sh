#!/bin/bash

password_dir=$(dirname $(readlink -f $0))
password_file=$password_dir/password.txt

if [ ! -f $password_file ]
then
  echo "File password.txt must exist to run this command"
  exit 1
fi

if [ "$#" -ne 0 ]
then
  echo Usage: "$0"
  exit 1
else
  mosquitto_pub -h kgb.club.cc.cmu.edu -u ctfwsmaster -P $(cat $password_file) -q 1 -r -t ctfws/game/config -m none
fi

