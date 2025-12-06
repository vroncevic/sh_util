#!/bin/bash
#
# @brief   Debug/Info/Question options, print function formats
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_DEVEL" ]; then
    readonly __SH_UTIL_DEVEL=1

    UTIL_DEVEL=devel
    UTIL_DEVEL_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_DEVEL_VERSION}

    .    ${UTIL}/bin/devel_check.sh

    # Debug/Info print mode
    TOOL_DBG="false"

    # Logging messages
    TOOL_LOG="false"

    # Send email notification
    TOOL_NOTIFY="false"

    #
    # @brief  Check status structure
    # @param  Value required referenced structure with statuses
    # @retval Success 0 (in case if it is TOOL_DBG a true), else 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # if is_debug_mode; then
    #    # debug mode enabled
    # else
    #    # debug mode disabled
    # fi
    #
    function is_debug_mode {
        [[ "${TOOL_DBG}" == "${TRUE}" ]]
    }

    #
    # @brief  Print question text message
    # @params Values required message, parent function name and tool name
    # @retval Success 0, else 1 (in case of missing arguments)
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # info_debug_que "$MSG" "$FUNC" "$TOOL"
    #
    function info_debug_message_que {
        local MSG=$1 PFUNC=$2 TOOL=$3 FUNC=${FUNCNAME[0]}
        if [[ -z "${MSG}" || -z "${PFUNC}" || -z "${TOOL}" ]]; then
            local USAGE_MSG="Missing argument(s) [MSG] || [PFUNC] || [TOOL]"
            printf "$SEND" "devel" "$FUNC" "$USAGE_MSG" >&2
            return $NOT_SUCCESS
        fi
        if is_debug_mode; then
            printf "$DQUE" "$TOOL" "$PFUNC" "$MSG"
        else
            printf "$SQUE" "$TOOL" "$MSG"
        fi
    }

    #
    # @brief  Print answer text message
    # @params Values required message, parent function name and tool name
    # @retval Success 0, else 1 (in case of missing arguments)
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # info_debug_message_ans "$MSG" "$FUNC" "$TOOL"
    #
    function info_debug_message_ans {
        local MSG=$1 PFUNC=$2 TOOL=$3 FUNC=${FUNCNAME[0]}
        if [[ -z "${MSG}" || -z "${PFUNC}" || -z "${TOOL}" ]]; then
            local USAGE_MSG="Missing argument(s) [MSG] || [PFUNC] || [TOOL]"
            printf "$SEND" "devel" "$FUNC" "$USAGE_MSG" >&2
            return $NOT_SUCCESS
        fi
        if is_debug_mode; then
            printf "$DANS" "$TOOL" "$PFUNC" "$MSG"
        else
            printf "$SANS" "$MSG"
        fi
    }

    #
    # @brief  Print standard text message
    # @params Values required message, parent function name and tool name
    # @retval Success 0, else 1 (in case of missing arguments)
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # info_debug_message "$MSG" "$FUNC" "$TOOL"
    #
    function info_debug_message {
        local MSG=$1 PFUNC=$2 TOOL=$3 FUNC=${FUNCNAME[0]}
        if [[ -z "${MSG}" || -z "${PFUNC}" || -z "${TOOL}" ]]; then
            local USAGE_MSG="Missing argument(s) [MSG] || [PFUNC] || [TOOL]"
            printf "$SEND" "devel" "$FUNC" "$USAGE_MSG" >&2
            return $NOT_SUCCESS
        fi
        if is_debug_mode; then
            printf "$DSTA" "$TOOL" "$PFUNC" "$MSG"
        else
            printf "$SSTA" "$TOOL" "$MSG"
        fi
    }

    #
    # @brief  Print end text message
    # @params Values required message, parent function name and tool name
    # @retval Success 0, else 1 (in case of missing arguments)
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # info_debug_message_end "$MSG" "$FUNC" "$TOOL"
    #
    function info_debug_message_end {
        local MSG=$1 PFUNC=$2 TOOL=$3 FUNC=${FUNCNAME[0]}
        if [[ -z "${MSG}" || -z "${PFUNC}" || -z "${TOOL}" ]]; then
            local USAGE_MSG="Missing argument(s) [MSG] || [PFUNC] || [TOOL]"
            printf "$SEND" "devel" "$FUNC" "$USAGE_MSG" >&2
            return $NOT_SUCCESS
        fi
        if is_debug_mode; then
            printf "$DEND" "$TOOL" "$PFUNC" "$MSG"
        else
            printf "$SEND" "$TOOL" "$MSG"
        fi
    }
fi
