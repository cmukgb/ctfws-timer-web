#!/bin/bash

# Get this script file. Since readlink -f doesn't work on every system, just
# return $0 if it fails. We don't support linking the script on those systems.
script_file=$(readlink -f "$0" 2> /dev/null || echo "$0")

# Sets $password_file
source $(dirname "$script_file")/mqtt_config.sh

zero_flags_arg="--zero-flags"

if [ "$#" -ne 3 ] && [ "$#" -ne 4 ] && [ "$#" -ne 5 ]
then
  echo "Usage: $0 num_flags game_num territory [timestamp] [$zero_flags_arg]"
  echo "       territory is either 'dw' (for red defending Doherty) or 'wd'"
  echo "If $zero_flags_arg is set, flags will be set to '0 0'"
  exit 1
else
  do_zero_flags=false
  num_flags="$1"
  game_num="$2"
  territory="$3"

  if [ "$territory" = "dw" ]
  then
    red="Doherty"
    yellow="Wean"
  elif [ "$territory" = "wd" ]
  then
    red="Wean"
    yellow="Doherty"
  else
    echo "Error: territory must be either 'dw' or 'wd'"
    exit 1
  fi

  if [ "$#" -eq 5 ]
  then
    if [ "$4" = "$zero_flags_arg" ]
    then
      d="$5"
      do_zero_flags=true
    elif [ "$5" = "$zero_flags_arg" ]
    then
      d="$4"
      do_zero_flags=true
    else
      echo "Error: Five arguments given, but none are $zero_flags_arg"
      exit 1
    fi
  elif [ "$#" -eq 4 ]
  then
    if [ "$4" = "$zero_flags_arg" ]
    then
			d=$(date +%s)
			do_zero_flags=true
    else
			d="$4"
			do_zero_flags=false
    fi
  else
    d=$(date +%s)
		do_zero_flags=false
  fi

  m="$d 900 4 900 $num_flags $game_num $territory"
  mosquitto_pub -h ${MQTT_HOST:-localhost} -u ctfwsmaster -P $(cat $password_file) -q 1 -r -t ctfws/game/config -m "$m" &&
  echo "Started game $game_num with $num_flags flags at $d (Red in $red / Yellow in $yellow)" &&

  if [ "$do_zero_flags" = true ]
  then
    $(dirname "$script_file")/set_flags.sh "0 0"
  fi
fi
