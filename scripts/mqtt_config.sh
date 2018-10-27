#!/bin/bash

expected_filename="password.txt"

password_file=""
if [ -f "$expected_filename" ]
then
  password_file="$expected_filename"
elif [ -f $(dirname "$0")/"$expected_filename" ]
then
  password_file=$(dirname "$0")/"$expected_filename"
elif [ -h "$0" ] # If script was symlinked, allow file to be at target of link
then
  password_dir=$(dirname $(readlink -f "$0"))
  temp_password_file="$password_dir"/"$expected_filename"
  if [ -f "$temp_password_file" ]
  then
    password_file="$temp_password_file"
  fi
fi

if [ -z "$password_file" ]
then
  echo "File $expected_filename must exist to run this command"
  exit 1
fi

if [ -r "$(dirname $password_file)/broker.txt" ]; then
  MQTT_HOST=$(cat "$(dirname $password_file)/broker.txt")
fi
