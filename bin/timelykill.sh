#!/bin/bash
#
# @brief   Kill process pid after n time
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=timelykill
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[PID]  Process ID"
    [ARG2]="[TIME] Time <n>s|m|h|d"
    [EX-PRE]="# Destroy process in <n>s|m|h|d"
    [EX]="__$UTIL_NAME freshtool 5s"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Check process id
# @param  Value required process id
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkpid "$PID"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __checkpid() {
    PID=$1
    if [ -n "$PID" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Check process id]"
		fi
        kill -0 $PID &>/dev/null 
        STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Receive signal [ok]"
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "Receive signal [not ok]"
		fi
        return $NOT_SUCCESS
    fi
    return $NOT_SUCCESS
}

#
# @brief  Validation of time argument
# @param  Value required time
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __time_validatesleep $TIME
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __time_validatesleep() {
    TIME=$1
    if [ -n "$TIME" ]; then 
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Validation of time argument]"
		fi
        case $1 in
            +([0-9])[smhd] ) 
					if [ "$TOOL_DEBUG" == "true" ]; then
						printf "%s\n\n" "[Done]"
					fi
                    return $SUCCESS
                    ;;
            *) 
					if [ "$TOOL_DEBUG" == "true" ]; then
						printf "%s\n\n" "[Error] Wrong argument"
					fi
                    return $NOT_SUCCESS
                    ;;
        esac
    fi
    return $NOT_SUCCESS
}

#
# @brief  Kill process pid after n time
# @params Values required process id and time 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __timelykill $PID $TIME
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __timelykill() {
    PID=$1
    TIME=$2
    if [ -n "$PID" ] && [ -n "$TIME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Kill process pid after n time]"
		fi
        case $PID in
            +([0-9])) 
                __time_validatesleep $TIME
                STATUS=$?
                if [ "$STATUS" -eq "$NOT_SUCCESS" ]; then
                    __usage $TOOL_USAGE
                    return $NOT_SUCCESS
                fi
                sleep $TIME
                while kill -0 $PID &>/dev/null 
                do
                    kill -15 $PID
                    __checkpid "$PID"
                    STATUS=$?
                    if [ "$STATUS" -eq "$NOT_SUCCESS" ]; then
                        kill  -3 $PID
                    fi
                    __checkpid "$PID"
                    STATUS=$?
                    if [ "$STATUS" -eq "$NOT_SUCCESS" ]; then
                        kill  -9 $PID
                    fi
                    __checkpid "$PID"
                    STATUS=$?
                    if [ "$STATUS" -eq "$NOT_SUCCESS" ]; then
						LOG[MSG]="Faild to kill process [$PID]"
						if [ "$TOOL_DEBUG" == "true" ]; then
                        	printf "%s\n\n" "[Error] ${LOG[MSG]}"
						fi
                        __logging $LOG
                        return $NOT_SUCCESS
                    fi
                done
                ;;
            *) 
                LOG[MSG]="Wrong argument"
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n\n" "${LOG[MSG]}"
				fi
                __logging $LOG
                return $NOT_SUCCESS
                ;;
        esac
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

