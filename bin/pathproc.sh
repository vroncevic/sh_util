#!/bin/bash
#
# @brief   Gives complete path name of process associated with pid
# @version ver.1.0
# @date    Mon Oct 12 22:02:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_PATHPROC=pathproc
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A PATHPROC_USAGE=(
    [TOOL_NAME]="__$UTIL_PATHPROC"
    [ARG1]="[PROCESS] Process ID"
    [EX-PRE]="# Example Gives complete path name of process"
    [EX]="__$UTIL_PATHPROC 1356"	
)

#
# @brief  Gives complete path name of process associated with pid
# @param  Value required process id
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local PROCESS="1356"
# __pathproc "$PROCESS"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | no such process
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __pathproc() {
    local PROCESS=$1
    if [ -n "$PROCESS" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local PROCFILE=exe
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Gives complete path name of process associated with pid"
			printf "$DSTA" "$UTIL_PATHPROC" "$FUNC" "$MSG"
		fi
        local pidno=$( ps ax | grep $1 | awk '{ print $1 }' | grep $1 )
        if [ -z "$pidno" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="No such process running [$PROCESS]"
            	printf "$DEND" "$UTIL_PATHPROC" "$FUNC" "$MSG"
			fi
            return $NOT_SUCCESS
        fi
        if [ ! -r "/proc/$1/$PROCFILE" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="Process [$1] is running"
				printf "$DSTA" "$UTIL_PATHPROC" "$FUNC" "$MSG"
			fi
			MSG="Can't get read permission on [/proc/$1/$PROCFILE]"
			printf "$SEND" "$UTIL_PATHPROC" "$MSG"
            return $NOT_SUCCESS
        fi  
        local exe_file=$(ls -l /proc/$1 | grep "exe" | awk '{ print $11 }')
        if [ -e "$exe_file" ]; then
            MSG="Process #$1 invoked by [$exe_file]"
			printf "$DSTA" "$UTIL_PATHPROC" "$FUNC" "$MSG"
        else
			MSG="No such process running"
			printf "$SEND" "$UTIL_PATHPROC" "$MSG"
            return $NOT_SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "$DEND" "$UTIL_PATHPROC" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage $PATHPROC_USAGE
    return $NOT_SUCCESS
}

