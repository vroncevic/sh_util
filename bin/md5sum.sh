#!/bin/bash
#
# @brief   Calculate md5sum from an input string
# @version ver.1.0
# @date    Tue Mar 15 16:35:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=md5sum
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[INPUT_STRING] input string"
    [EX-PRE]="# Calculate md5sum from an input string"
    [EX]="__$UTIL_NAME simpletest"	
)

#
# @brief  Calculate md5sum from an input string
# @param  Value required input string
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __md5sum "$INPUT_STRING"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __md5sum() {
    INPUT_STRING=$1
    if [ -n "$INPUT_STRING" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Calculate md5sum from an input string]"
		fi
        md5sum<<<"$INPUT_STRING" | cut -f1 -d' ';
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

