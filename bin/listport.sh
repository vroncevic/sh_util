#!/bin/bash
#
# @brief   List target port
# @version ver.1.0
# @date    Mon Jun 02 21:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=listport
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[PORT] Which you need to check"
    [EX-PRE]="# Example check port 1734"
    [EX]="__$UTIL_NAME 1734"	
)

#
# @brief  Check port
# @param  Value required target port (port number)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __listport "1734"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __listport {
    TARGET_PORT=$1
    if [ -n "$TARGET_PORT" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[Checking port]"
		fi
        netstat -lpdn | grep $TARGET_PORT
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi 
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

