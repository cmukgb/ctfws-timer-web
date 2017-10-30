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

