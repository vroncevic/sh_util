#!/bin/bash
#
# @brief   Kill process pid after n time
# @version ver.1.0.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_TIMELY_KILL=timely_kill
UTIL_TIMELY_KILL_VERSION=ver.1.0.0
UTIL=/root/scripts/sh_util/${UTIL_TIMELY_KILL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A TIMELY_KILL_USAGE=(
    [USAGE_TOOL]="${UTIL_TIMELY_KILL}"
    [USAGE_ARG1]="[PID]  Process ID"
    [Usage_ARG2]="[TIME] Time <n>s|m|h|d"
    [USAGE_EX_PRE]="# Destroy process in <n>s|m|h|d"
    [USAGE_EX]="${UTIL_TIMELY_KILL} freshtool 5s"
)

#
# @brief  Check process id
# @param  Value required process id
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# check_pid "$PID"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | bad signal
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function check_pid {
    local PID=$1
    if [ -n "${PID}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Checking process id [${PID}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
        kill -0 $PID &>/dev/null
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
            info_debug_message_end "Done" "$FUNC" "$UTIL_TIMELY_KILL"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
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
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# time_validate_sleep $TIME
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | wrong argument
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function time_validate_sleep {
    local TIME=$1
    if [ -n "${TIME}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Validation of time argument [${TIME}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
        if [[ ${TIME} == +([0-9])[smhd] ]]; then
            info_debug_message_end "Done" "$FUNC" "$UTIL_TIMELY_KILL"
            return $SUCCESS
        else
            MSG="Wrong argument!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
            return $NOT_SUCCESS
        fi
    fi
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
    return $NOT_SUCCESS
}

#
# @brief  Kill process pid after n time
# @params Values required process id and time 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# timely_kill $PID $TIME
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s) | wrong argument
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function timely_kill {
    local PID=$1 TIME=$2
    if [[ -n "${PID}" && -n "${TIME}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Kill process pid [${PID}] after [${TIME}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
        if [[ ${PID} == +([0-9]) ]]; then
            time_validate_sleep ${TIME}
            STATUS=$?
            if [ $STATUS -eq $NOT_SUCCESS ]; then
                usage TIMELY_KILL_USAGE
                return $NOT_SUCCESS
            fi
            sleep ${TIME}
            while kill -0 ${PID} &>/dev/null
            do
                kill -15 ${PID}
                check_pid "${PID}"
                STATUS=$?
                if [ $STATUS -eq $NOT_SUCCESS ]; then
                    kill -3 ${PID}
                fi
                check_pid "${PID}"
                STATUS=$?
                if [ $STATUS -eq $NOT_SUCCESS ]; then
                    kill -9 ${PID}
                fi
                check_pid "${PID}"
                STATUS=$?
                if [ $STATUS -eq $NOT_SUCCESS ]; then
                    MSG="Process [${PID}] is running!"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
                    MSG="Force exit!"
                    info_debug_message_end "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
                    return $NOT_SUCCESS
                fi
            done
        else
            MSG="Wrong argument!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_TIMELY_KILL"
            return $NOT_SUCCESS
        fi
        info_debug_message "Done" "$FUNC" "$UTIL_TIMELY_KILL"
        return $SUCCESS
    fi
    usage TIMELY_KILL_USAGE
    return $NOT_SUCCESS
}

