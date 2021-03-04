#!/bin/bash
#
# @brief   Write message to named pipe
# @version ver.1.0.0
# @date    Mon Oct 22 19:52:32 2018
# @company None, free  software to use 2018
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_NAMED_PIPE_WRITER=named_pipe_writer
UTIL_NAMED_PIPE_WRITER_VERSION=ver.1.0.0
UTIL=/root/scripts/sh_util/${UTIL_NAMED_PIPE_WRITER_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A NAMED_PIPE_WRITER_Usage=(
    [USAGE_TOOL]="${UTIL_NAMED_PIPE_WRITER}"
    [USAGE_ARG1]="[PIPE_PATH] Absolute path of named pipe"
    [Usage_ARG2]="[MESSAGE]   Message for pipe"
    [USAGE_EX_PRE]="# Write message to named pipe"
    [USAGE_EX]="${UTIL_NAMED_PIPE_WRITER} /tmp/testpipe 'Simple test'"
)

#
# @brief  Write message to named pipe
# @params Value required pipe path and message
# @retval Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local PIPE_PATH=/tmp/testpipe
# local MSG="Simple test"
# named_pipe_writer PIPE_PATH MSG
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function named_pipe_writer {
    local PIPE_PATH=$1 MESSAGE=$2
    if [[ -n "${PIPE_PATH}" && -n "${MESSAGE}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Checking named pipe ?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_NAMED_PIPE_WRITER"
        test -f $PIPE_PATH
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            info_debug_message_ans "[ok]" "$FUNC" "$UTIL_NAMED_PIPE_WRITER"
            echo $MESSAGE > $PIPE_PATH
            info_debug_message_end "Done" "$FUNC" "$UTIL_NAMED_PIPE_WRITER"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_NAMED_PIPE_WRITER"
        MSG="Create named pipe !"
        info_debug_message "$MSG" "$FUNC" "$UTIL_NAMED_PIPE_WRITER"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_NAMED_PIPE_WRITER"
        return $NOT_SUCCESS
    fi
    usage NAMED_PIPE_WRITER_Usage
    return $NOT_SUCCESS
}

