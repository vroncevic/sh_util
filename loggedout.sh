#!/bin/bash
#
# @brief   Notify when a particular user has logged out
# @version ver.1.0
# @date    Fri Oct 16 20:46:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=loggedout
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL"
    [ARG1]="[USER_NAME] System username"
    [ARG1]="[TIME]      Time for wainting on log out"
    [EX-PRE]="# Checking user to log out"
    [EX]="__$TOOL rmuller 5"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Notify when a particular user has logged out
# @params Values required username and time
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __loggedout $USER_NAME $TIME
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __loggedout() {
    USER_NAME=$1
    TIME=$2
    if [ -n "$USER_NAME" ] && [ -n "$TIME" ]; then
        who | grep "^$1 " 2>&1 > /dev/null 
        if [[ $? != 0 ]]; then
            printf "%s\n" "User [$USER_NAME] is not logged in"
            return $SUCCESS
        fi
        while who | grep "^$1 "; do
            sleep $TIME
        done
        printf "%s\n" "User [$USER_NAME] just logged out..."
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
