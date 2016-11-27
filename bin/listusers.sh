#!/bin/bash
#
# @brief   Print all common user names
# @version ver.1.0
# @date    Mon Oct 16 20:11:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LISTUSERS=listusers
UTIL_LISTUSERS_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_LISTUSERS_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A LISTUSERS_USAGE=(
    [TOOL]="__$UTIL_LISTUSERS"
    [ARG1]="[ID] Minimal user id"
    [EX-PRE]="# Example print all common user names"
    [EX]="__$UTIL_LISTUSERS 500"	
)

#
# @brief  Print all common user names
# @param  Value required ID
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local ID=1000
# __listusers "$ID"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
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
function __listusers() {
    local ID=$1
    if [ -n "$ID" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Print all common user names started from id [$ID]"
			printf "$DSTA" "$UTIL_LISTUSERS" "$FUNC" "$MSG"
		fi
        awk -F: '$3 >= '$ID' {print $1}' /etc/passwd
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_LISTUSERS" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage $LISTUSERS_USAGE
    return $NOT_SUCCESS
}

