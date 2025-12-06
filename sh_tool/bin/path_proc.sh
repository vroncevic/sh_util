#!/bin/bash
#
# @brief   Gives complete path name of process associated with pid
# @version ver.1.0
# @date    Mon Oct 12 22:02:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_PATH_PROC" ]; then
    readonly __SH_UTIL_PATH_PROC=1

    UTIL_PATH_PROC=path_proc
    UTIL_PATH_PROC_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_PATH_PROC_VERSION}
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/usage.sh

    declare -A PATH_PROC_USAGE=(
        [USAGE_TOOL]="${UTIL_PATH_PROC}"
        [USAGE_ARG1]="[PROCESS] Process ID"
        [USAGE_EX_PRE]="# Example Gives complete path name of process"
        [USAGE_EX]="${UTIL_PATH_PROC} 1356"
    )

    #
    # @brief  Gives complete path name of process associated with pid
    # @param  Value required process id
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # local PROCESS="1356" STATUS
    # path_proc "$PROCESS"
    # STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # missing argument | no such process
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function path_proc {
        local PROCESS=$1
        if [ -z "${PROCESS}" ]; then
            usage PATH_PROC_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None" PROCFILE=exe PIDNO EXE_FILE
        MSG="Gives complete path name of process associated with pid!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_PATH_PROC"
        PIDNO=$(ps ax | grep ${PROCESS} | awk '{ print $1 }' | grep ${PROCESS})
        if [ -z "${PIDNO}" ]; then
            MSG="No such process running [${PROCESS}]!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_PATH_PROC"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_PATH_PROC"
            return $NOT_SUCCESS
        fi
        if [ ! -r "/proc/${PROCESS}/${PROCFILE}" ]; then
            MSG="Process [${PROCESS}] is running!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_PATH_PROC"
            MSG="Can't get read permission on [/proc/${PROCESS}/${PROCFILE}]!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_PATH_PROC"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_PATH_PROC"
            return $NOT_SUCCESS
        fi
        EXE_FILE=$(ls -l /proc/${PROCESS} | grep "exe" | awk '{ print $11 }')
        if [ -e "${EXE_FILE}" ]; then
            MSG="Process #${PROCESS} invoked by [${EXE_FILE}]"
            info_debug_message "$MSG" "$FUNC" "$UTIL_PATH_PROC"
        else
            MSG="No such process running"
            info_debug_message "$MSG" "$FUNC" "$UTIL_PATH_PROC"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_PATH_PROC"
            return $NOT_SUCCESS
        fi
        info_debug_message_end "Done" "$FUNC" "$UTIL_PATH_PROC"
        return $SUCCESS
    }
fi
