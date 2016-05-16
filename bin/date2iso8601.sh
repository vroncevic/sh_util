#!/bin/bash
#
# @brief   Converts DD/MM/YYYY date format to ISO-8601 (YYYY-MM-DD)
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=date2iso8601
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[TOOL_NAME] Name of App/Tool/Script"
    [EX-PRE]="# Converting time to iso8601"
    [EX]="__$UTIL_NAME \"tester.log\""	
)
#
# @brief  Converts DD/MM/YYYY date format to ISO-8601 (YYYY-MM-DD)
# @param  Value required file name 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __date2iso8601 "$FILE_NAME"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __date2iso8601() {
    FILE_NAME=$1
    if [ -n "$FILE_NAME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Converts DD/MM/YYYY date format to ISO-8601 (YYYY-MM-DD)]"
		fi
        sed 's_\([0-9]\{1,2\}\)/\([0-9]\{1,2\}\)/\([0-9]\{4\}\)_\3-\2-\1_g' $FILE_NAME
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi 
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

