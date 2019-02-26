#!/bin/bash

# Get this script file. Since readlink -f doesn't work on every system, just
# return $0 if it fails. We don't support linking the script on those systems.
script_file=$(readlink -f "$0" 2> /dev/null || echo "$0")

# Sets $password_file
source $(dirname "$script_file")/get_password.sh

zero_flags_arg="--zero-flags"
send_message_arg="--send-message"

if [ "$#" -ne 3 ] && [ "$#" -ne 4 ] && [ "$#" -ne 5 ] && [ "$#" -ne 6 ]
then
  echo "Usage: $0 num_flags game_num territory [timestamp] [$zero_flags_arg] [$send_message_arg]"
  echo "       territory is either 'dw' (for red defending Doherty) or 'wd'"
  echo "If $zero_flags_arg is set, flags will be set to '0 0'"
  echo "If $send_message_arg is set, a default initial message will be sent"
  exit 1
else
  do_zero_flags=false
  do_send_message=false
  num_flags="$1"
  game_num="$2"
  territory="$3"
  date=""

  shift 3

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

  while [ "$#" -gt 0 ]
  do
    if [ "$1" = "$zero_flags_arg" ]
    then
      do_zero_flags=true
    elif [ "$1" = "$send_message_arg" ]
    then
      do_send_message=true
    else
      if [ "$date" != "" ]
      then
        echo "Error: Two potential arguments given for timestamp: \"$date\" and \"$1\""
        exit 1
      fi
      date="$1"
    fi
    shift
  done

  if [ "$date" = "" ]
  then
    date=$(date +%s)
  fi

  m="$date 900 4 900 $num_flags $game_num $territory"
  mosquitto_pub -u ctfwsmaster -P $(cat $password_file) -q 1 -r -t ctfws/game/config -m "$m" &&
  echo "Started game $game_num with $num_flags flags at $date (Red in $red / Yellow in $yellow)" &&

  if [ "$do_zero_flags" = true ]
  then
    $(dirname "$script_file")/set_flags.sh "0 0"
  fi

  if [ "$do_send_message" = true ]
  then
    $(dirname "$script_file")/send_player_message.sh "Red is defending $red. Yellow is defending $yellow." "$date" &&
    $(dirname "$script_file")/send_jail_message.sh "R=$red Y=$yellow" "$date"
  fi
fi
