#!/bin/bash
#
# @brief   Check Process, is running or not
# @version ver.1.0
# @date    Wed Sep 16 17:41:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#  
TOOL_NAME=checkprocess
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh
. $TOOL_BIN/checktool.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL_NAME"
    [ARG2]="[PROCESS_NAME] Process name"
    [EX-PRE]="# Example check ddclient process"
    [EX]="__$TOOL_NAME ddclient"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Check process (is alive or not)
# @argument Value required process name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkprocess $PROCESS
# CHECK_PROCESS=$?
#
# if [ $CHECK_PROCESS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __checkprocess() {
    PROCESS=$1
    if [ -n "$PROCESS" ]; then
        printf "%s" "Checking process [$PROCESS] "
        PIDS=`ps cax | grep $PROCESS | grep -o '^[ ]*[0-9]*'`
        if [ -z "$PIDS" ]; then
            printf "%s\n" "[no instance]"
            return $SUCCESS
        fi
        printf "%s\n" "[process alredy running]"
        return $NOT_SUCCESS
    fi 
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
} 
