#!/bin/bash
#
# @brief   Kill process pid after n time
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=timelykill
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
    [TOOL_NAME]="__$TOOL"
    [ARG1]="[PID]  Process ID"
    [ARG2]="[TIME] Time <n>s|m|h|d"
    [EX-PRE]="# Destroy process in <n>s|m|h|d"
    [EX]="__$TOOL freshtool 5s"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Check process id
# @argument Value required process id
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkpid $PID
# CHECK_PID=$?
#
# if [ $CHECK_PID -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __checkpid() {
    PID=$1
    if [ -n "$PID" ]; then
        kill -0 $PID &>/dev/null 
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            printf "%s\n" "Receive signal [ok]"
            return $SUCCESS
        fi
        printf "%s\n" "Receive signal [not ok]"
        return $NOT_SUCCESS
    fi
    return $NOT_SUCCESS
}

#
# @brief Validation of time argument
# @argument Value required time
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __time_validatesleep $TIME
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __time_validatesleep() {
    TIME=$1
    if [ -n "$TIME" ]; then 
        case $1 in
            +([0-9])[smhd] ) 
                return $SUCCESS
                ;;
            *) 
                return $NOT_SUCCESS
                ;;
        esac
    fi
    return $NOT_SUCCESS
}

#
# @brief Kill process pid after n time
# @params Values required process id and time 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __timelykill $PID $TIME
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __timelykill() {
    PID=$1
    TIME=$2
    if [ -n "$PID" ] && [ -n "$TIME" ]; then
        case $PID in
            +([0-9])) 
                __time_validatesleep $TIME
                STATUS=$?
                if [ $STATUS -eq $NOT_SUCCESS ]; then
                    __usage $TOOL_USAGE
                    return $NOT_SUCCESS
                fi
                sleep $TIME
                while kill -0 $PID &>/dev/null 
                do
                    kill -15 $PID
                    __checkpid $PID
                    CHECK_PID=$?
                    if [ $CHECK_PID -eq $NOT_SUCCESS ]; then
                        kill  -3 $PID
                    fi
                    __checkpid $PID
                    CHECK_PID=$?
                    if [ $CHECK_PID -eq $NOT_SUCCESS ]; then
                        kill  -9 $PID
                    fi
                    __checkpid $PID
                    CHECK_PID=$?
                    if [ $CHECK_PID -eq $NOT_SUCCESS ]; then
                        printf "%s\n" "Faild to kill process [$PID]!"
                        return $NOT_SUCCESS
                    fi
                done
                ;;
            *) 
                __usage $TOOL_USAGE
                LOG[MSG]="Wrong argument"
                __logging $LOG
                return $NOT_SUCCESS
                ;;
        esac
        printf "%s\n" "Done..."
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
