#!/bin/bash
#
# @brief   Gives complete path name of process associated with pid
# @version ver.1.0
# @date    Mon Oct 12 22:02:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=pathproc
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL_NAME"
    [ARG1]="[PROCESS] Process ID"
    [EX-PRE]="# Example Gives complete path name of process"
    [EX]="__$TOOL_NAME 1356"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

PROCFILE=exe

#
# @brief Gives complete path name of process associated with pid
# @argument Value required Process ID
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __pathproc $PROCESS
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __pathproc() {
    PROCESS=$1
    if [ -n "$PROCESS" ]; then
        pidno=$( ps ax | grep $1 | awk '{ print $1 }' | grep $1 )
        if [ -z "$pidno" ]; then
            printf "%s\n" "No such process running [$PROCESS]"
            return $NOT_SUCCESS
        fi
        if [ ! -r "/proc/$1/$PROCFILE" ]; then
            printf "%s\n" "Process [$1] running, but..."
            printf "%s\n" "Can't get read permission on [/proc/$1/$PROCFILE]"
            return $NOT_SUCCESS
        fi  
        exe_file=$(ls -l /proc/$1 | grep "exe" | awk '{ print $11 }')
        if [ -e "$exe_file" ]; then
            printf "%s\n" "Process #$1 invoked by [$exe_file]"
        else
            printf "%s\n" "No such process running"
            return $NOT_SUCCESS
        fi
        printf "Done..."
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
