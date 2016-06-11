#!/bin/bash
#
# @brief   Calculate md5sum from an input string
# @version ver.1.0
# @date    Tue Mar 15 16:35:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_MD5SUM=md5sum
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A MD5SUM_USAGE=(
    [TOOL_NAME]="__$UTIL_MD5SUM"
    [ARG1]="[INPUT_STRING] input string"
    [EX-PRE]="# Calculate md5sum from an input string"
    [EX]="__$UTIL_MD5SUM simpletest"	
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
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __md5sum() {
    local INPUT_STRING=$1
    if [ -n "$INPUT_STRING" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local MD5SUM="/usr/bin/md5sum"
		__checktool "$MD5SUM"
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Calculate md5sum from an input string"
				printf "$DSTA" "$UTIL_MD5SUM" "$FUNC" "$MSG"
			fi
			eval "$MD5SUM<<<"$INPUT_STRING" | cut -f1 -d' ';"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$UTIL_MD5SUM" "$FUNC" "Done"
			fi
			return $SUCCESS
        fi
        return $NOT_SUCCESS
    fi
    __usage $MD5SUM_USAGE
    return $NOT_SUCCESS
}
