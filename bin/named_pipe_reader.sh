#!/bin/bash
#
# @brief   Read message from named pipe and send to function-handler
# @version ver.1.0
# @date    Mon Oct 22 19:52:32 2018
# @company None, free  software to use 2018
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_NAMED_PIPE_READER=named_pipe_writer
UTIL_NAMED_PIPE_READER_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_NAMED_PIPE_READER_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A NAMED_PIPE_READER_USAGE=(
    [USAGE_TOOL]="${UTIL_NAMED_PIPE_READER}"
    [USAGE_ARG1]="[PIPE_PATH]    Absolute path of named pipe"
    [USAGE_ARG2]="[MESSAGE_STOP] Message for pipe"
    [USAGE_ARG3]="[HANDLER]      Function to be executed"
    [USAGE_EX_PRE]="# Read message from named pipe and provide to process_func"
    [USAGE_EX]="${UTIL_NAMED_PIPE_READER} /tmp/testpipe 'QUIT' process_func"
)

#
# @brief  Read message from named pipe and send to function handler
# @params Value required pipe path, stop_message and handler function
# @retval Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local PIPE_PATH=/tmp/testpipe
# local MSG="MESSAGE_STOP"
# named_pipe_reader PIPE_PATH MSG HANDLER
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
function named_pipe_reader {
    local PIPE_PATH=$1 MESSAGE_STOP=$2
    eval local HANDLER=$3
    if [[ -n "${PIPE_PATH}" && -n "${MESSAGE_STOP}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Checking named pipe ?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_NAMED_PIPE_READER"
        test -f $PIPE_PATH
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            info_debug_message_ans "[ok]" "$FUNC" "$UTIL_NAMED_PIPE_READER"
            MSG="Checking handler type ?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_NAMED_PIPE_READER"
            if [ "$(type -t ${HANDLER})" = "function" ]; then
                info_debug_message_ans "[ok]" "$FUNC" "$UTIL_NAMED_PIPE_READER"
                mkfifo ${PIPE_PATH}
                while true
                do
                    read line <${PIPE_PATH}
                    if [[ -n "${line}" ]]; then
                        if [[ "$line" == "${MESSAGE_STOP}" ]]; then
                            rm -f $PIPE_PATH
                            break
                        fi
                        ${HANDLER} $line
                    fi
                done
                info_debug_message_end "Done" "$FUNC" "$UTIL_NAMED_PIPE_READER"
                return $SUCCESS
            fi
            MSG="[not ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_NAMED_PIPE_READER"
            MSG="Provide function as handler !"
            info_debug_message "$MSG" "$FUNC" "$UTIL_NAMED_PIPE_READER"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_NAMED_PIPE_READER"
            return $NOT_SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_NAMED_PIPE_READER"
        MSG="Create named pipe !"
        info_debug_message "$MSG" "$FUNC" "$UTIL_NAMED_PIPE_READER"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_NAMED_PIPE_READER"
        return $NOT_SUCCESS
    fi
    usage NAMED_PIPE_READER_USAGE
    return $NOT_SUCCESS
}

