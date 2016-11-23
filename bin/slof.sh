#!/bin/bash
#
# @brief   Show 10 Largest Open Files
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SLOF=slof
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A SLOF_USAGE=(
    [TOOL_NAME]="__$UTIL_SLOF"
    [ARG1]="[SIZE] LIst in GB/MB"
    [EX-PRE]="# Show 10 Largest Open Files in GB"
    [EX]="__$UTIL_SLOF large"	
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
function __slof() {
    local SIZE=$1
    if [ -n "$SIZE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Show 10 Largest Open Files"
			printf "$DSTA" "$UTIL_SLOF" "$FUNC" "$MSG"
		fi
		local AWK_CMD_G='{if($7 > 1048576) print $7/1048576 "GB" " " $9 " " $1}'
		local AWK_CMD_M='{if($7 > 1048576) print $7/1048576 "MB" " " $9 " " $1}'
        if [ "$SIZE" == "large" ]; then
            eval "lsof / | awk $AWK_CMD_G | sort -n -u | tail"
        else
            eval "lsof / | awk $AWK_CMD_M | sort -n -u | tail"
        fi
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_SLOF" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage $SLOF_USAGE
    return $NOT_SUCCESS
}

