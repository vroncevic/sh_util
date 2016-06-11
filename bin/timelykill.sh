#!/bin/bash
#
# @brief   Kill process pid after n time
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_TIMELYKILL=timelykill
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TIMELYKILL_USAGE=(
    [TOOL_NAME]="__$UTIL_TIMELYKILL"
    [ARG1]="[PID]  Process ID"
    [ARG2]="[TIME] Time <n>s|m|h|d"
    [EX-PRE]="# Destroy process in <n>s|m|h|d"
    [EX]="__$UTIL_TIMELYKILL freshtool 5s"	
)

declare -A LOG=(
    [TOOL]="$UTIL_TIMELYKILL"
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
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | bad signal
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __checkpid() {
    local PID=$1
    if [ -n "$PID" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Check process id [$PID]"
			printf "$DSTA" "$UTIL_TIMELYKILL" "$FUNC" "$MSG"
		fi
        kill -0 $PID &>/dev/null 
        local STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="Receive signal [ok]"
            	printf "$DEND" "$UTIL_TIMELYKILL" "$FUNC" "$MSG"
				printf "$DEND" "$UTIL_TIMELYKILL" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Receive signal [not ok]"
			printf "$DEND" "$UTIL_TIMELYKILL" "$FUNC" "$MSG"
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
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | wrong argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __time_validatesleep() {
    local TIME=$1
    if [ -n "$TIME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Validation of time argument [$TIME]"
			printf "$DSTA" "$UTIL_TIMELYKILL" "$FUNC" "$MSG"
		fi
        case $TIME in
            +([0-9])[smhd] ) 
					if [ "$TOOL_DBG" == "true" ]; then
						printf "$DEND" "$UTIL_TIMELYKILL" "$FUNC" "Done"
					fi
                    return $SUCCESS
                    ;;
            *) 
					MSG="Wrong argument"
					printf "$SEND" "$UTIL_TIMELYKILL" "$MSG"
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
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | wrong argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __timelykill() {
    local PID=$1
    local TIME=$2
    if [ -n "$PID" ] && [ -n "$TIME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Kill process pid [$PID] after [$TIME]"
			printf "$DSTA" "$UTIL_TIMELYKILL" "$FUNC" "$MSG"
		fi
        case $PID in
            +([0-9])) 
                __time_validatesleep $TIME
                local STATUS=$?
                if [ "$STATUS" -eq "$NOT_SUCCESS" ]; then
                    __usage $TIMELYKILL_USAGE
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
						MSG="${LOG[MSG]}"
						printf "$SEND" "$UTIL_TIMELYKILL" "$MSG"
                        __logging $LOG
                        return $NOT_SUCCESS
                    fi
                done
                ;;
            *)
                MSG="Wrong argument"
				printf "$SEND" "$UTIL_TIMELYKILL" "$MSG"
                return $NOT_SUCCESS
                ;;
        esac
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "$DEND" "$UTIL_TIMELYKILL" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage $TIMELYKILL_USAGE
    return $NOT_SUCCESS
}
