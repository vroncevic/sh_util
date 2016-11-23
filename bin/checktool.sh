#!/bin/bash
#
# @brief   Checking tool (does exist and, is executable)
# @version ver.1.0
# @date    Mon Jul 15 20:57:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CHECKTOOL=checktool
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A CHECKTOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_CHECKTOOL"
    [ARG1]="[TOOL_NAME] Path to App/Tool/Script"
    [EX-PRE]="# Example checking java tool"
    [EX]="__$UTIL_CHECKTOOL /usr/share/java"
)

#
# @brief  Checking tool (does exist and, is executable)
# @param  Value required path to App/Tool/Script file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local TOOL="/usr/bin/java"
# __checktool "$TOOL"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | tool doesn't exist
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __checktool() {
    local APP_TOOL_NAME=$1
    if [ -n "$APP_TOOL_NAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Checking tool [$APP_TOOL_NAME]"
        	printf "$DQUE" "$UTIL_CHECKTOOL" "$FUNC" "$MSG"
		fi
        if [ -e "$APP_TOOL_NAME" ] && [ -x "$APP_TOOL_NAME" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	printf "%s\n" "[ok]"
				printf "$DEND" "$UTIL_CHECKTOOL" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
			printf "%s\n" "[not ok]"
		fi
		MSG="Please check tool [$APP_TOOL_NAME]"
		printf "$SEND" "$UTIL_CHECKTOOL" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage $CHECKTOOL_USAGE
    return $NOT_SUCCESS
}

