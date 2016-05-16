#!/bin/bash
#
# @brief   Print all common user names
# @version ver.1.0
# @date    Mon Oct 16 20:11:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=listusers
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[ID] Minimal user id"
    [EX-PRE]="# Example print all common user names"
    [EX]="__$UTIL_NAME 500"	
)

#
# @brief  Print all common user names
# @param  Value required ID
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __listusers "$ID"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __listusers() {
    ID=$1
    if [ -n "$ID" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Print all common user names]"
		fi
        awk -F: '$3 >= '$ID' {print $1}' /etc/passwd
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

