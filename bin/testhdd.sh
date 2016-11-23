#!/bin/bash
#
# @brief   Test hard drive speed
# @version ver.1.0
# @date    Thu Mar 03 15:06:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_TESTHDD=testhdd
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TESTHDD_USAGE=(
    [TOOL_NAME]="__$UTIL_TESTHDD"
    [ARG1]="[TIME_COUNT] Time count"
    [EX-PRE]="# Creating zerofile and test hdd"
    [EX]="__$UTIL_TESTHDD 500"	
)

#
# @brief  Test hard drive speed
# @param  Value required time count
# @retval Success return 0, else return 1
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __testhdd $TIME_COUNT
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __testhdd() {
    local TIME_COUNT=$1
    if [ -n "$TIME_COUNT" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Testing hard drive speed"
			printf "$DSTA" "$UTIL_TESTHDD" "$FUNC" "$MSG"
		fi
        time (dd if=/dev/zero of=zerofile bs=1M count=$TIME_COUNT;sync);
        rm zerofile
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_TESTHDD" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage $TESTHDD_USAGE
    return $NOT_SUCCESS
}

