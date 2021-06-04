#!/bin/bash
#
# @brief   Remove empty leading spaces from an ascii file
#          and replace input file
# @version ver.1.0
# @date    Sun Oct 04 22:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_RM_LEADS=rm_leads
UTIL_RM_LEADS_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_RM_LEADS_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A RM_LEADS_Usage=(
    [USAGE_TOOL]="${UTIL_RM_LEADS}"
    [USAGE_ARG1]="[FILES] Name of file"
    [USAGE_EX_PRE]="# Remove empty leading spaces from an ascii file"
    [USAGE_EX]="${UTIL_RM_LEADS} /data/test.txt"
)

#
# @brief  Remove empty leading spaces from an ascii file 
#             and replace input file
# @param  Value required name of ascii file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# rm_leads "$FILE_PATH"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s)
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function rm_leads {
    local FILES=$@
    if [ -n "${FILES}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS A
        MSG="Remove leading spaces from ascii file and replace input file!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_RM_LEADS"
        local TMP=/tmp/tmp.${RANDOM}$$
        trap 'rm -f $TMP >/dev/null 2>&1' 0
        trap "exit 1" 1 2 3 15
        for A in "${FILES[@]}"
        do
            MSG="Checking file [${A}]?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_RM_LEADS"
            if [ -f "${A}" ]; then
                MSG="[ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_RM_LEADS"
                file "${A}" | grep -q text
                STATUS=$?
                if [ $STATUS -eq $SUCCESS ]; then
                    sed 's/^[     ]*//' < "${A}" > "${TMP}" && mv "${TMP}" "${A}"
                else
                    MSG="File [${A}] is not an ascii type!"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_RM_LEADS"
                fi
            else
                MSG="[not ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_RM_LEADS"
                MSG="Please check file [${A}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_RM_LEADS"
            fi
        done
        info_debug_message_end "Done" "$FUNC" "$UTIL_RM_LEADS"
        return $SUCCESS
    fi
    usage RM_LEADS_Usage
    return $NOT_SUCCESS
}

