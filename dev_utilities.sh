#!/bin/bash
############################## DEV_SCRIPT_MARKER ##############################
# This script is used to document and run recurring tasks in development.     #
#                                                                             #
# You can run your tasks using the script `./dev some-task`.                  #
# You can install the Sandstorm Dev Script Runner and run your tasks from any #
# nested folder using `dev some-task`.                                        #
# https://github.com/sandstorm/Sandstorm.DevScriptRunner                      #
###############################################################################

set -e

####### Utilities #######

_echo_green() {
  printf "\033[0;32m%s\033[0m\n" "${1}"
}
_echo_yellow() {
  printf "\033[1;33m%s\033[0m\n" "${1}"
}
_echo_red() {
  printf "\033[0;31m%s\033[0m\n" "${1}"
}
