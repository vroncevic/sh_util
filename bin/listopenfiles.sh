#!/bin/bash
#
# @brief   List opened files by specific user
# @version ver.1.0
# @date    Mon Oct 12 22:04:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=listopenfiles
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[USER_NAME] System username"
    [EX-PRE]="# Example list all opened files by user"
    [EX]="__$UTIL_NAME rmuller"	
)

#
# @brief  List opened files by specific user
# @param  Value required username
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __listopenfiles "$USER_NAME"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __listopenfiles() {
    USER_NAME=$1
    if [ -n "$USER_NAME" ]; then
		if [ "$TOOL_DEBUG" == "treu" ]; then
			printf "%s\n" "[List opened files by specific user]"
		fi
        lsof -u $USER_NAME
		if [ "$TOOL_DEBUG" == "treu" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

