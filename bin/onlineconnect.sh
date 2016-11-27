#!/bin/bash
#
# @brief   Test point po point connection
# @version ver.1.0
# @date    Sun Oct 11 02:08:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ONLINECONNECT=onlineconnect
UTIL_ONLINECONNECT_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_ONLINECONNECT_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh

declare -A ONLINECONNECT_USAGE=(
    [USAGE_TOOL]="__$UTIL_ONLINECONNECT"
    [USAGE_ARG1]="[TIME] Sleep time"
    [USAGE_EX_PRE]="# Example running __$TOOL"
    [USAGE_EX]="__$UTIL_ONLINECONNECT 5s"	
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
# if [ $STATUS -eq $SUCCESS ]; then
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
	local INTERVAL=$1
	if [ -n "$INTERVAL" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		local PID_NUM="None"
		declare -A configonlineconnectutil=()
		__loadutilconf "$UTIL_APPSHORTCUT_CFG" configonlineconnectutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local procname=${configonlineconnectutil[PROCNAME]}
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
		fi
		return $NOT_SUCCESS
	fi
	__usage ONLINECONNECT_USAGE
	return $NOT_SUCCESS
}

