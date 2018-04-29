#!/bin/bash

# Get this script file. Since readlink -f doesn't work on every system, just
# return $0 if it fails. We don't support linking the script on those systems.
script_file=$(readlink -f "$0" 2> /dev/null || echo "$0")

# Sets $password_file
source $(dirname "$script_file")/get_password.sh

if [ "$#" -ne 0 ]
then
  echo "Usage: $0"
  exit 1
else
  mosquitto_pub -u ctfwsmaster -P $(cat "$password_file") -q 1 -r -t ctfws/game/config -m none &&
  echo "Set to no game" &&
  $(dirname "$script_file")/set_flags.sh "0 0"
fi
