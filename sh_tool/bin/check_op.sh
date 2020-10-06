#!/bin/bash
#
# @brief   Checking operation to be done
# @version ver.1.0.0
# @date    Thu Apr 28 20:40:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CHECK_OP=check_op
UTIL_CHECK_OP_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_CHECK_OP_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A CHECK_OP_Usage=(
    [Usage_TOOL]="${UTIL_CHECK_OP}"
    [Usage_ARG1]="[OP] Operation to be done"
    [Usage_ARG2]="[OPLIST] List of operations"
    [Usage_EX_PRE]="# Example checking operation"
    [Usage_EX]="${UTIL_CHECK_OP} \"restart\" \"\${OPLIST[*]\""
)

#
# @brief  Checking operation to be done
# @params Values required operation and list of operations
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local OP="restart" OPLIST=( start stop restart version )
#
# check_op "$OP" "${OPLIST[*]}"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | missing tool
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function check_op {
    local OP=$1
    OPLIST=($2)
    if [[ -n "${OP}" && -n "${OPLIST}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" I
        MSG="Checking operation [${OP}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_CHECK_OP"
        for I in "${OPLIST[@]}"
        do
            if [ "${OP}" == "${I}" ]; then
                info_debug_message_ans "[ok]" "$FUNC" "$UTIL_CHECK_OP"
                info_debug_message_end "Done" "$FUNC" "$UTIL_CHECK_OP"
                return $SUCCESS
            fi
            :
        done
        info_debug_message_ans "[not ok]" "$FUNC" "$UTIL_CHECK_OP"
        MSG="Please check operation [${OP}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_CHECK_OP"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_CHECK_OP"
        return $NOT_SUCCESS
    fi
    usage CHECK_OP_Usage
    return $NOT_SUCCESS
}

