#!/bin/bash
#
# @brief   Show 10 Largest Open Files
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=slof
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[SIZE] LIst in GB/MB"
    [EX-PRE]="# Show 10 Largest Open Files in GB"
    [EX]="__$UTIL_NAME large"	
)

#
# @brief  Show 10 Largest Open Files
# @param  Value required size in GB or MB
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __slof 10
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __slof() {
    SIZE=$1
    if [ -n "$SIZE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Show 10 Largest Open Files]"
		fi
        if [ "$SIZE" == "large" ]; then
            lsof / | awk '{ if($7 > 1048576) print $7/1048576 "GB" " " $9 " " $1 }' | sort -n -u | tail
        else
            lsof / | awk '{ if($7 > 1048576) print $7/1048576 "MB" " " $9 " " $1 }' | sort -n -u | tail
        fi
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

