#!/bin/bash
#
# @brief   Print name of the file that contains lines longer then n chars
# @version ver.1.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LONGER_LINES=longer_lines
UTIL_LONGER_LINES_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_LONGER_LINES_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A LONGER_LINES_USAGE=(
    [USAGE_TOOL]="__${UTIL_LONGER_LINES}"
    [USAGE_ARG1]="[NUMCHARS] an integer referring to min characters per line"
    [USAGE_EX_PRE]="# Print file name, that contain lines longer then 45 chars"
    [USAGE_EX]="__${UTIL_LONGER_LINES} 45"
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
    if [[ -n "${NUMCHARS}" && -n "${FILES}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" A COUNTER LINE
        MSG="Print file name that contains lines longer then n chars!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_LONGER_LINES"
        case ${NUMCHARS} in
            +([0-9]))
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
                ;;
            *)
                MSG="Wrong argument!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_LONGER_LINES"
                MSG="Force exit!"
                info_debug_message_end "$MSG" "$FUNC" "$UTIL_LONGER_LINES"
                return $NOT_SUCCESS
                ;;
        esac
        info_debug_message_end "Done" "$FUNC" "$UTIL_LONGER_LINES"
        return $SUCCESS
    fi
    usage LONGER_LINES_USAGE
    return $NOT_SUCCESS
}

