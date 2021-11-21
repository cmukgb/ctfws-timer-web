#!/bin/bash

# Get this script file. Since readlink -f doesn't work on every system, just
# return $0 if it fails. We don't support linking the script on those systems.
script_file=$(readlink -f "$0" 2> /dev/null || echo "$0")

# Sets $password_file
source $(dirname "$script_file")/get_password.sh

zero_flags_arg="--zero-flags"
send_message_arg="--send-message"
setup_duration_arg="--setup-duration"
rounds_arg="--rounds"
round_duration_arg="--round-duration"

DEFAULT_SETUP_DURATION="900"
DEFAULT_ROUNDS="4"
DEFAULT_ROUND_DURATION="900"

player_message_template='Red is defending $red. Yellow is defending $yellow.'
jail_message_template='R=$red Y=$yellow'

if [ "$#" -lt 3 ]
then
  echo "Usage: $0 num_flags game_num territory [timestamp] [$zero_flags_arg] [$send_message_arg] [$setup_duration_arg setup_duration] [$rounds_arg rounds] [$round_duration_arg round_duration]"
  echo "       territory is either 'dw' (for red defending Doherty) or 'wd'"
  echo "If $zero_flags_arg is set, flags will be set to '0 0'"
  echo "If $send_message_arg is set, a default initial message will be sent"
  echo "       Message for players: \"$player_message_template\""
  echo "       Message for jails: \"$jail_message_template\""
  echo "Custom game configuration can be specified; default is:"
  echo "       $setup_duration_arg $DEFAULT_SETUP_DURATION"
  echo "       $rounds_arg $DEFAULT_ROUNDS"
  echo "       $round_duration_arg $DEFAULT_ROUND_DURATION"
  exit 1
else
  do_zero_flags=false
  do_send_message=false
  setup_duration="$DEFAULT_SETUP_DURATION"
  rounds="$DEFAULT_ROUNDS"
  round_duration="$DEFAULT_ROUND_DURATION"
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
      shift
    elif [ "$1" = "$send_message_arg" ]
    then
      do_send_message=true
      shift
    elif [ "$1" = "$setup_duration_arg" ]
    then
      setup_duration=$2
      shift 2
    elif [ "$1" = "$rounds_arg" ]
    then
      rounds=$2
      shift 2
    elif [ "$1" = "$round_duration_arg" ]
    then
      round_duration=$2
      shift 2
    else
      if [ "$date" != "" ]
      then
        echo "Error: Two potential arguments given for timestamp: \"$date\" and \"$1\""
        exit 1
      fi
      date="$1"
      shift
    fi
  done

  if [ "$date" = "" ]
  then
    date=$(date +%s)
  fi

  m="$date $setup_duration $rounds $round_duration $num_flags $game_num $territory"
  mosquitto_pub -u ctfwsmaster -P $(cat $password_file) -q 1 -r -t ctfws/game/config -m "$m" &&
  echo "Started game $game_num with $num_flags flags at $date (Red in $red / Yellow in $yellow)" &&
  echo "    Setup duration: $setup_duration seconds"
  echo "    Rounds: $rounds rounds"
  echo "    Round duration: $round_duration seconds"

  if [ "$do_zero_flags" = true ]
  then
    $(dirname "$script_file")/set_flags.sh "0 0"
  fi

  if [ "$do_send_message" = true ]
  then
    player_message=$(eval echo "$player_message_template")
    $(dirname "$script_file")/send_player_message.sh "$player_message" "$date" &&
    jail_message=$(eval echo "$jail_message_template")
    $(dirname "$script_file")/send_jail_message.sh "$jail_message" "$date"
  fi
fi
