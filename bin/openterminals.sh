#!/bin/bash
#
# @brief   Opens n terminal windows
# @version ver.1.0
# @date    Tue Mar 03 16:58:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_OPENTERMINALS=openterminals
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/chectool.sh
. $UTIL/bin/devel.sh

declare -A OPENTERMINALS_USAGE=(
    [TOOL_NAME]="__$UTIL_OPENTERMINALS"
    [ARG1]="[NUM_TERMINALS] number of terminal windows"
    [EX-PRE]="# Open 4 terminal windows"
    [EX]="__$UTIL_OPENTERMINALS 4"	
)

#
# @brief  Opens n terminal windows
# @param  Value required number of terminal windows
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __openterminals "$NUM_TERMINALS"
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
function __openterminals() {
    local NUM_TERMINALS=$1
    if [ -n "$NUM_TERMINALS" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local TERM="/usr/bin/terminator"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Opens n terminal windows"
			printf "$DSTA" "$UTIL_OPENTERMINALS" "$FUNC" "$MSG"
		fi
        __checktool "$TERM"
        local STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
            local i=0
            while [ $i -lt $NUM_TERMINALS ]
            do
                eval "$TERM &"
                i=$[$i+1]
            done
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$UTIL_OPENTERMINALS" "$FUNC" "Done"
			fi
			return $SUCCESS
        fi
        return $NOT_SUCCESS
    fi
    __usage $OPENTERMINALS_USAGE
    return $NOT_SUCCESS
}

