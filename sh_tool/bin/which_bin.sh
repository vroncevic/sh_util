#!/bin/bash
#
# @brief   Locate binary executable file 
# @version ver.1.0.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_WHICH_BIN=which_bin
UTIL_WHICH_BIN_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_WHICH_BIN_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A WHICH_BIN_USAGE=(
    [USAGE_TOOL]="${UTIL_WHICH_BIN}"
    [USAGE_ARG1]="[PATH] Path to destionation"
    [USAGE_EX_PRE]="# Example running tool"
    [USAGE_EX]="${UTIL_WHICH_BIN} /data/"
)

#
# @brief  Show links
# @param  Value required path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# follow_link "$PATH"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | not an executable file
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function follow_link {
    local FILE=$1
    if [ -n "${FILE}" ]; then
        local FILE=$(which "${FILE}") FUNC=${FUNCNAME[0]} MSG="None"
        if [ ${FILE} -eq $NOT_SUCCESS ]; then
            MSG="[${FILE}] is not an executable!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_WHICH_BIN"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_WHICH_BIN"
            return $NOT_SUCCESS
        fi
        if [ -L "${FILE}" ]; then
            MSG="Symbolic Link [${FILE}]!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_WHICH_BIN"
            cd $(dirname "${FILE}")
            follow_link $(set -- $(ls -l "${FILE}"); shift 10; echo "${FILE}")
        else
            ls -l "${FILE}"
        fi
        info_debug_message_end "Done" "$FUNC" "$UTIL_WHICH_BIN"
        return $SUCCESS
    fi
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$UTIL_WHICH_BIN"
    return $NOT_SUCCESS
}

#
# @brief  Show links and path to executable
# @param  Value required path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# which_bin "$PATH"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function which_bin {
    local FILES=$@
    if [ -n "${FILES}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Locate bin!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_WHICH_BIN"
        for A in ${FILES[@]}
        do
            follow_link "${A}"
        done
        info_debug_message_end "Done" "$FUNC" "$UTIL_WHICH_BIN"
        return $SUCCESS
    fi
    usage WHICH_BIN_USAGE
    return $NOT_SUCCESS
}

