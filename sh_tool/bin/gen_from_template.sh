#!/bin/bash
#
# @brief   Generating file by template
# @version ver.1.0.0
# @date    Mon Mar  6 19:25:19 CET 2017
# @company None, free software to use 2017
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_GEN_FROM_TEMPLATE=gen_from_template
UTIL_GEN_FROM_TEMPLATE_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_GEN_FROM_TEMPLATE_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A GEN_FROM_TEMPLATE_USAGE=(
    [USAGE_TOOL]="${UTIL_GEN_FROM_TEMPLATE}"
    [USAGE_ARG1]="[INPUT FILE] Template file"
    [USAGE_ARG2]="[OUTPUT FILE] Final result file"
    [USAGE_EX_PRE]="# Example generating from template file"
    [USAGE_EX]="${UTIL_GEN_FROM_TEMPLATE} \"\$INF\" \"\$OUTF\""
)

#
# @brief  Generating file by template
# @params Values required input (template) and output (result) file
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# gen_from_template "${INF}" "${OUTF}"
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
function gen_from_template {
    local INF=$1 OUTF=$2
    if [[ -n "${INF}" && -n "${OUTF}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" LINE
        MSG="Checking template file [${INF}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_GEN_FROM_TEMPLATE"
        if [ -e "${INF}" ]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_GEN_FROM_TEMPLATE"
            while read LINE
            do
                eval echo "${LINE}" >> "${OUTF}"
            done < "${INF}"
            info_debug_message_end "Done" "$FUNC" "$UTIL_GEN_FROM_TEMPLATE"
            return $SUCCESS
        fi
        info_debug_message_ans "[not ok]" "$FUNC" "$UTIL_GEN_FROM_TEMPLATE"
        MSG="Check file [${INF}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_GEN_FROM_TEMPLATE"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_GEN_FROM_TEMPLATE"
        return $NOT_SUCCESS
    fi
    usage GEN_FROM_TEMPLATE_USAGE
    return $NOT_SUCCESS
}

