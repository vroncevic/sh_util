#!/bin/bash
#
# @brief   Checking tool (does exist and, is executable)
# @version ver.1.0.0
# @date    Mon Jul 15 20:57:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CHECK_TOOL=check_tool
UTIL_CHECK_TOOL_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_CHECK_TOOL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A CHECK_TOOL_Usage=(
    [Usage_TOOL]="${UTIL_CHECK_TOOL}"
    [Usage_ARG1]="[TOOL] Path to App/Tool/Script"
    [Usage_EX_PRE]="# Example checking java tool"
    [Usage_EX]="${UTIL_CHECK_TOOL} /usr/share/java"
)

#
# @brief  Checking tool (does exist and, is executable)
# @param  Value required path to App/Tool/Script file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local TOOL="/usr/bin/java" STATUS
# check_tool "$TOOL"
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | tool doesn't exist
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function check_tool {
    local TOOL=$1
    if [ -n "${TOOL}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Checking tool [${TOOL}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_CHECK_TOOL"
        if [ -e "${TOOL}" ] && [ -x "${TOOL}" ]; then
            info_debug_message_ans "[ok]" "$FUNC" "$UTIL_CHECK_TOOL"
            info_debug_message_end "Done" "$FUNC" "$UTIL_CHECK_TOOL"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CHECK_TOOL"
        MSG="Please check tool [${TOOL}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_CHECK_TOOL"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_CHECK_TOOL"
        return $NOT_SUCCESS
    fi
    usage CHECK_TOOL_Usage
    return $NOT_SUCCESS
}

