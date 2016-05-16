#!/bin/bash
#
# @brief   Checking X Server
# @version ver.1.0
# @date    Fri Okt 04 17:55:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=checkx
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[XINIT] Instance of tool for running X session"
    [EX-PRE]="# Example checking X Server"
    [EX]="__$UTIL_NAME \"xinit\""
)

#
# @brief  Checking X Server
# @param  Value required name of init process
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkx "xinit"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __checkx() {
    X=$1
    if [ -n "$X" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Checking X Server on $HOSTNAME]"
        	printf "%s" "X Server "
		fi
        XINIT=$(ps aux | grep -q $X)
        if [ "$XINIT" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "[up and running]"
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[down]"
			printf "%s\n\n" "[Done]"
		fi
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

