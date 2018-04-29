#!/bin/bash

# Get this script file. Since readlink -f doesn't work on every system, just
# return $0 if it fails. We don't support linking the script on those systems.
script_file=$(readlink -f "$0" 2> /dev/null || echo "$0")

# Sets $password_file
source $(dirname "$script_file")/get_password.sh

hide_flags_arg="--hide-flags"

if [ "$#" -ne 0 ] && [ "$#" -ne 1 ] && [ "$#" -ne 2 ]
then
  echo "Usage: $0 [$hide_flags_arg] [timestamp]"
  echo "If $hide_flags_arg is set, flags will be set to ?"
  exit 1
else
	do_hide_flags=false
  if [ "$#" -eq 2 ]
  then
    if [ "$1" = "$hide_flags_arg" ]
    then
      d="$2"
      do_hide_flags=true
    elif [ "$2" = "$hide_flags_arg" ]
    then
      d="$1"
      do_hide_flags=true
    else
      echo "Error: Two arguments given, but neither is $hide_flags_arg"
      exit 1
    fi
  elif [ "$#" -eq 1 ]
  then
    if [ "$1" = "$hide_flags_arg" ]
    then
			d=$(date +%s)
			do_hide_flags=true
    else
			d="$1"
			do_hide_flags=false
    fi
  else # 0 arguments
    d=$(date +%s)
		do_hide_flags=false
  fi

  mosquitto_pub -u ctfwsmaster -P $(cat "$password_file") -q 1 -r -t ctfws/game/endtime -m "$d" &&
  echo "Ended game at $d" &&

  if [ "$do_hide_flags" = true ]
  then
    $(dirname "$script_file")/set_flags.sh "?"
  fi
fi
