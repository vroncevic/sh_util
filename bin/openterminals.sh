#!/bin/bash
#
# @brief   Opens n terminal windows
# @version ver.1.0
# @date    Tue Mar 03 16:58:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=openterminals
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/chectool.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[NUM_TERMINALS] number of terminal windows"
    [EX-PRE]="# Open 4 terminal windows"
    [EX]="__$UTIL_NAME 4"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
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
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __openterminals() {
    NUM_TERMINALS=$1
    if [ -n "$NUM_TERMINALS" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Opens n terminal windows]"
		fi
        __checktool "/usr/bin/terminator"
        STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
            i=0
            while [ $i -lt $NUM_TERMINALS ]
            do
                terminator &
                i=$[$i+1]
            done
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Done]"
			fi
			return $SUCCESS
        fi
        LOG[MSG]="Check tool terminator"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $TOOL_LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

