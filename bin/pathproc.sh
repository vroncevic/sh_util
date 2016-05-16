#!/bin/bash
#
# @brief   Gives complete path name of process associated with pid
# @version ver.1.0
# @date    Mon Oct 12 22:02:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=pathproc
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[PROCESS] Process ID"
    [EX-PRE]="# Example Gives complete path name of process"
    [EX]="__$UTIL_NAME 1356"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

PROCFILE=exe

#
# @brief  Gives complete path name of process associated with pid
# @param  Value required process id
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __pathproc "$PROCESS"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __pathproc() {
    PROCESS=$1
    if [ -n "$PROCESS" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Gives complete path name of process associated with pid]"
		fi
        pidno=$( ps ax | grep $1 | awk '{ print $1 }' | grep $1 )
        if [ -z "$pidno" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "No such process running [$PROCESS]"
			fi
            return $NOT_SUCCESS
        fi
        if [ ! -r "/proc/$1/$PROCFILE" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Process [$1] running, but..."
			fi
			LOG[MSG]="Can't get read permission on [/proc/$1/$PROCFILE]"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n\n" "[Error] ${LOG[MSG]}"
			fi
            __logging $LOG
            return $NOT_SUCCESS
        fi  
        exe_file=$(ls -l /proc/$1 | grep "exe" | awk '{ print $11 }')
        if [ -e "$exe_file" ]; then
            printf "%s\n" "Process #$1 invoked by [$exe_file]"
        else
			LOG[MSG]="No such process running"            
			if [ "$TOOL_DEBUG" == "true" ]; then			
				printf "%s\n\n" "[Error] ${LOG[MSG]}"
			fi
            __logging $LOG
            return $NOT_SUCCESS
        fi
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

