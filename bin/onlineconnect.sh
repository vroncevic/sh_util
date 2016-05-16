#!/bin/bash
#
# @brief   Test point po point connection
# @version ver.1.0
# @date    Sun Oct 11 02:08:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=onlineconnect
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[TIME] Life time"
    [EX-PRE]="# Example running __$TOOL_NAME"
    [EX]="__$UTIL_NAME 5s"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

PROCNAME=pppd
INTERVAL=2

#
# @brief  Test point po point connection
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __onlineconnect
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __onlineconnect() {
    PID_NUMBER=$(ps ax | grep -v "ps ax" | grep -v grep | grep "$PROCNAME" | awk '{ print $1 }')
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n" "[Test point po point connection]"
	fi
    if [ -z "$PID_NUMBER" ] && [ -n "$PID_NUMBER" ]; then
		LOG[MSG]="Not connected"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi        
        __logging $LOG
        return $NOT_SUCCESS
    fi
    while [ true ]
    do
        if [ ! -e "/proc/$PID_NUMBER/$PROCFILENAME" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "Disconnected"
			fi
            return $NOT_SUCCESS
        fi
        netstat -s | grep "Packets received"
        netstat -s | grep "Packets delivered"
        sleep $INTERVAL
    done
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n\n" "[Done]"
	fi
    return $SUCCESS
}

