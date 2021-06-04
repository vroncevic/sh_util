#!/bin/bash
#
# @brief   Strips out the comments (/* COMMENT */) in a C program
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_STRIP_COMMENT=strip_comment
UTIL_STRIP_COMMENT_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_STRIP_COMMENT_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A STRIP_COMMENT_USAGE=(
    [USAGE_TOOL]="${UTIL_STRIP_COMMENT}"
    [USAGE_ARG1]="[FILE] Path to C file code"
    [USAGE_EX_PRE]="# Strips comments from C code"
    [USAGE_EX]="${UTIL_STRIP_COMMENT} /opt/test.c"
)

#
# @brief  Strips out the comments (/* COMMENT */) in a C program
# @param  Value required path to C code
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# strip_comment "$FILE"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | not ascii TYPE of file
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function strip_comment {
    local FILE=$1
    if [ -n "${FILE}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Checking Code File [${FILE}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_STRIP_COMMENT"
        if [ -e "${FILE}" ]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_STRIP_COMMENT"
            local TYPE=`file ${FILE} | awk '{ print $2, $3, $4, $5 }'`
            local CORRECT_TYPE="ASCII C program text"
            MSG="Check type of file [${FILE}]?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_STRIP_COMMENT"
            if [ "$TYPE" != "${CORRECT_TYPE}" ]; then
                MSG="[not ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_STRIP_COMMENT"
                MSG="This script works on C program files only!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_STRIP_COMMENT"
                MSG="Force exit!"
                info_debug_message_end "$MSG" "$FUNC" "$UTIL_STRIP_COMMENT"
                return $NOT_SUCCESS
            fi
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_STRIP_COMMENT"
            sed '/^\/\*/d /.*\*\//d' ${FILE}
            info_debug_message_end "Done" "$FUNC" "$UTIL_STRIP_COMMENT"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_STRIP_COMMENT"
        MSG="Please check file [${FILE}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_STRIP_COMMENT"
        MSG="Force exit!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_STRIP_COMMENT"
        return $NOT_SUCCESS
    fi
    usage STRIP_COMMENT_USAGE
    return $NOT_SUCCESS
}

