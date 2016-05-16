#!/bin/bash
#
# @brief   Test hard drive speed
# @version ver.1.0
# @date    Thu Mar 03 15:06:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=testhdd
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[TIME_COUNT] Time count"
    [EX-PRE]="# Creating zerofile and test hdd"
    [EX]="__$UTIL_NAME 500"	
)

#
# @brief  Test hard drive speed
# @param  Value required time count
# @retval Success return 0, else return 1
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __testhdd $TIME_COUNT
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __testhdd() {
    TIME_COUNT=$1
    if [ -n "$TIME_COUNT" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Test hard drive speed]"
		fi
        time (dd if=/dev/zero of=zerofile bs=1M count=$TIME_COUNT;sync);
        rm zerofile
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

