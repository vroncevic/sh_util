#!/bin/bash
#
# @brief   Checking process, is running or not
# @version ver.1.0
# @date    Wed Sep 16 17:41:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#  
UTIL_CHECKPROCESS=checkprocess
UTIL_CHECKPROCESS_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_CHECKPROCESS_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A CHECKPROCESS_USAGE=(
    [TOOL]="__$UTIL_CHECKPROCESS"
    [ARG1]="[PROCESS_NAME] Process name"
    [EX-PRE]="# Example check ddclient process"
    [EX]="__$UTIL_CHECKPROCESS ddclient"	
)

#
# @brief  Checking process (is running or not)
# @param  Value required process name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local PROCESS="java"
# __checkprocess "$PROCESS"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# process is not running
#	# notify admin | user
# else
#   # false
#	# missing argument | process alredy running
#	# notify admin | user
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __checkprocess() {
    local PROCESS=$1
    if [ -n "$PROCESS" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking process [$PROCESS]"
			printf "$DQUE" "$UTIL_CHECKPROCESS" "$FUNC" "$MSG"
		fi
        local PIDS=`ps cax | grep $PROCESS | grep -o '^[ ]*[0-9]*'`
        if [ -z "$PIDS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "%s\n" "[not running]"
				printf "$DEND" "$UTIL_CHECKPROCESS" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "%s\n" "[process alredy running]"
			printf "$DEND" "$UTIL_CHECKPROCESS" "$FUNC" "Done"
		fi
        return $NOT_SUCCESS
    fi 
    __usage $CHECKPROCESS_USAGE
    return $NOT_SUCCESS
}

