#!/bin/bash
set -e

green_echo() {
  printf "\033[0;32m%s\033[0m\n" "${1}"
}

red_echo() {
  printf "\033[0;31m%s\033[0m\n" "${1}"
}

mkdir -p /app/Data/Logs/Exceptions

inotifywait -m /app/Data/Logs/Exceptions -e create -e moved_to |
    while read dir action file; do
        red_echo "################################################################################################"
        red_echo "### Flow exception: '$file' (directory: '$dir', action: '$action')"
        # do something with the file
        cat $dir/$file
        red_echo "### end exception"
        red_echo "################################################################################################"
    done & \
    tail -f -n 5 /app/Data/Logs/*.log
