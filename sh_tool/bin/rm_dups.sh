#!/bin/bash
#
# @brief   Remove duplicate lines from file or stdin
# @version ver.1.0
# @date    Sun Oct 04 22:28:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_RM_DUPS=rm_dups
UTIL_RM_DUPS_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_RM_DUPS_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A RM_DUPS_Usage=(
    [USAGE_TOOL]="${UTIL_RM_DUPS}"
    [USAGE_ARG1]="[STREAM] stdin or file path"
    [USAGE_EX_PRE]="# Remove duplicate lines from file or stdin"
    [USAGE_EX]="${UTIL_RM_DUPS} /data/test.txt"
)

#
# @brief  Remove duplicate lines from file or stdin
# @param  Value required stdin or file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# rm_dups "$FILE_PATH"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s) | missing file
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function rm_dups {
    local FILES=$@
    if [ -n "${FILES}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Remove duplicate lines from file or stdin!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_RM_DUPS"
        if [ -f "${FILES}" ]; then
            cat "${FILES[@]}" | {
                awk '!x[$0]++'
            }
            info_debug_message_end "Done" "$FUNC" "$UTIL_RM_DUPS"
            return $SUCCESS
        fi
        MSG="Please check file(s) [${FILES}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_RM_DUPS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_RM_DUPS"
        return $NOT_SUCCESS
    fi
    usage RM_DUPS_Usage
    return $NOT_SUCCESS
}

