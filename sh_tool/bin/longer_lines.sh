#!/bin/bash
#
# @brief   Print name of the file that contains lines longer then n chars
# @version ver.1.0
# @date    Fri Okt 02 09:59:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_LONGER_LINES" ]; then
    readonly __SH_UTIL_LONGER_LINES=1

    UTIL_LONGER_LINES=longer_lines
    UTIL_LONGER_LINES_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_LONGER_LINES_VERSION}
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/usage.sh

    declare -A LONGER_LINES_USAGE=(
        [USAGE_TOOL]="${UTIL_LONGER_LINES}"
        [USAGE_ARG1]="[NUMCHARS] an integer referring to min characters per line"
        [USAGE_EX_PRE]="# Print file name, that contain lines longer then 45 chars"
        [USAGE_EX]="${UTIL_LONGER_LINES} 45"
    )

    #
    # @brief  Print name of the file that contains lines longer then n chars
    # @params Values required number of characters and files
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # longer_lines $NUMCHARS ${FILES[@]}
    # local STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # missing argument(s) | wrong argument(s)
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function longer_lines {
        local NUMCHARS=$1 FILES
        shift
        FILES=$@
        if [[ -z "${NUMCHARS}" || -z "${FILES}" ]]; then
            usage LONGER_LINES_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None" A COUNTER LINE
        MSG="Print file name that contains lines longer then n chars!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_LONGER_LINES"
        if [[ ${NUMCHARS} == +([0-9]) ]]; then
            for A in "${FILES[@]}"
            do
                COUNTER=0
                IFS=\n
                while read LINE
                do
                    if [[ ${#LINE} > ${NUMCHARS} ]]; then
                        printf "%s %s %s\n" \
                        "Chars: ${#LINE}" \
                        "Line#: ${COUNTER}" \
                        "File: ${A}"
                    fi
                    ((COUNTER++))
                done < ${A}
            done
        else
            MSG="Wrong argument!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_LONGER_LINES"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_LONGER_LINES"
            return $NOT_SUCCESS
        fi
        info_debug_message_end "Done" "$FUNC" "$UTIL_LONGER_LINES"
        return $SUCCESS
    }
fi
