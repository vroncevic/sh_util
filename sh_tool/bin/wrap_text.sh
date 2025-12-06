#!/bin/bash
#
# @brief   Wrap text file at 80th column, replace file with the wrapped version
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_WRAP_TEXT" ]; then
    readonly __SH_UTIL_WRAP_TEXT=1

    UTIL_WRAP_TEXT=wrap_text
    UTIL_WRAP_TEXT_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_WRAP_TEXT_VERSION}
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/usage.sh

    declare -A WRAP_TEXT_USAGE=(
        [USAGE_TOOL]="${UTIL_WRAP_TEXT}"
        [USAGE_ARG1]="[PATH] Path to the target(s)"
        [USAGE_EX_PRE]="# Example running tool"
        [USAGE_EX]="${UTIL_WRAP_TEXT} /data/"
    )

    #
    # @brief  Wrap text file at 80th column, replace file with the wrapped version
    # @param  Value required file
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # wrap_text "$FILES"
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
    function wrap_text {
        local FILES=$@
        if [ -z "${FILES}" ]; then
            usage WRAP_TEXT_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None" A
        for A in "${FILES[@]}"
        do
            if [ -f "${A}" ]; then
                MSG="Processing file [${A}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_WRAP_TEXT"
                fmt -w 80 -s ${A} > /tmp/$$.tmp
                mv /tmp/$$.tmp ${A}
            else
                MSG="Check file [${A}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_WRAP_TEXT"
            fi
        done
        info_debug_message_end "Done" "$FUNC" "$UTIL_WRAP_TEXT"
        return $SUCCESS
    }
fi
