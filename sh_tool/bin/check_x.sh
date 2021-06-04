#!/bin/bash
#
# @brief   Checking X Server instance
# @version ver.1.0
# @date    Fri Okt 04 17:55:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CHECK_X=check_x
UTIL_CHECK_X_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_CHECK_X_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A CHECK_X_Usage=(
    [USAGE_TOOL]="${UTIL_CHECK_X}"
    [USAGE_ARG1]="[XINIT] Instance of tool for running X session"
    [USAGE_EX_PRE]="# Example checking X Server"
    [USAGE_EX]="${UTIL_CHECK_X} \"xinit\""
)

#
# @brief  Checking X Server
# @param  Value required name of init process
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# check_x "xinit"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | X server isn't running
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function check_x {
    local X=$1
    if [ -n "${X}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" XINIT
        MSG="Checking X Server on [${HOSTNAME}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_CHECK_X"
        XINIT=$(ps aux | grep -q ${X})
        if [ $XINIT -eq $SUCCESS ]; then
            MSG="[up and running]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CHECK_X"
            info_debug_message_end "Done" "$FUNC" "$UTIL_CHECK_X"
            return $SUCCESS
        fi
        MSG="[down]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CHECK_X"
        MSG="Please check X Server on [${HOSTNAME}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_CHECK_X"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_CHECK_X"
        return $NOT_SUCCESS
    fi
    usage CHECK_X_Usage
    return $NOT_SUCCESS
}

