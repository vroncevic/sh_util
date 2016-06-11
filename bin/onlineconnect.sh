#!/bin/bash
#
# @brief   Test point po point connection
# @version ver.1.0
# @date    Sun Oct 11 02:08:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ONLINECONNECT=onlineconnect
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A ONLINECONNECT_USAGE=(
    [TOOL_NAME]="__$UTIL_ONLINECONNECT"
    [ARG1]="[TIME] Life time"
    [EX-PRE]="# Example running __$TOOL_NAME"
    [EX]="__$UTIL_ONLINECONNECT 5s"	
)

#
# @brief  Test point po point connection
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __onlineconnect
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # not connected | disconnected
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __onlineconnect() {
    local FUNC=${FUNCNAME[0]}
    local MSG=""
    local PROCNAME="/usr/sbin/pppd"
	local INTERVAL=2
	local PID_NUM=""
	if [ "$TOOL_DBG" == "true" ]; then
		MSG="Test point po point connection"
		printf "$DSTA" "$UTIL_ONLINECONNECT" "$FUNC" "$MSG"
	fi
	PID_NUM=$(ps ax | grep -v "ps ax" | grep -v grep | grep pppd | awk '{ print $1 }')
    if [ -z "$PID_NUM" ] && [ -n "$PID_NUM" ]; then
		MSG="Not connected"
		printf "$SEND" "$UTIL_ONLINECONNECT" "$MSG"
        return $NOT_SUCCESS
    fi
    while [ true ]
    do
        if [ ! -e "/proc/$PID_NUM/$PROCFILENAME" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="Disconnected"
				printf "$DSTA" "$UTIL_ONLINECONNECT" "$FUNC" "$MSG"
			fi
            return $NOT_SUCCESS
        fi
        netstat -s | grep "Packets received"
        netstat -s | grep "Packets delivered"
        sleep $INTERVAL
    done
	if [ "$TOOL_DBG" == "true" ]; then
		printf "$DEND" "$UTIL_ONLINECONNECT" "$FUNC" "Done"
	fi
    return $SUCCESS
}
