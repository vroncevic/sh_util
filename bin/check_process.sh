#!/bin/bash
#
# @brief   Checking process, is running or not
# @version ver.1.0
# @date    Wed Sep 16 17:41:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#  
UTIL_CHECK_PROCESS=check_process
UTIL_CHECK_PROCESS_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_CHECK_PROCESS_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A CHECK_PROCESS_USAGE=(
    [USAGE_TOOL]="${UTIL_CHECK_PROCESS}"
    [USAGE_ARG1]="[PROCESS_NAME] Process name"
    [USAGE_EX_PRE]="# Example check ddclient process"
    [USAGE_EX]="${UTIL_CHECK_PROCESS} ddclient"
)

#
# @brief  Checking process (is running or not)
# @param  Value required process name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local PROCESS="java" STATUS
# check_process "$PROCESS"
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # process is not running
#    # notify admin | user
# else
#    # false
#    # missing argument | process alredy running
#    # notify admin | user
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function check_process {
    local PROCESS=$1
    if [ -n "${PROCESS}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" PIDS
        MSG="Checking process [${PROCESS}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_CHECK_PROCESS"
        PIDS=`ps cax | grep ${PROCESS} | grep -o '^[ ]*[0-9]*'`
        if [ -z "${PIDS}" ]; then
            MSG="[not running]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CHECK_PROCESS"
            info_debug_message_end "Done" "$FUNC" "$UTIL_CHECK_PROCESS"
            return $SUCCESS
        fi
        MSG="[running]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CHECK_PROCESS"
        info_debug_message_end "Done" "$FUNC" "$UTIL_CHECK_PROCESS"
        return $NOT_SUCCESS
    fi
    usage CHECK_PROCESS_USAGE
    return $NOT_SUCCESS
}

