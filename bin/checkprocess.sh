#!/bin/bash
#
# @brief   Check process, is it running or not
# @version ver.1.0
# @date    Wed Sep 16 17:41:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#  
UTIL_NAME=checkprocess
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG2]="[PROCESS_NAME] Process name"
    [EX-PRE]="# Example check ddclient process"
    [EX]="__$UTIL_NAME ddclient"	
)

#
# @brief  Check process (is alive or not)
# @param  Value required process name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkprocess "$PROCESS"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __checkprocess() {
    PROCESS=$1
    if [ -n "$PROCESS" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Checking process]"
        	printf "%s" "Target process [$PROCESS] "
		fi
        PIDS=`ps cax | grep $PROCESS | grep -o '^[ ]*[0-9]*'`
        if [ -z "$PIDS" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "[no instance]"
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[process alredy running]"
			printf "%s\n\n" "[Done]"
		fi
        return $NOT_SUCCESS
    fi 
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
} 

