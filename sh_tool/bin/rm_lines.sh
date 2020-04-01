#!/bin/bash
#
# @brief   Remove lines that contain words stored in a list
# @version ver.1.0.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_RM_LINES=rm_lines
UTIL_RM_LINES_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_RM_LINES_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A RM_LINES_USAGE=(
    [USAGE_TOOL]="${UTIL_RM_LINES}"
    [USAGE_ARG1]="[IFILE]  Name of file for operation"
    [USAGE_ARG2]="[OFILE] Name of the resulting file"
    [USAGE_EX_PRE]="# Create a file n bytes large"
    [USAGE_EX]="${UTIL_RM_LINES} /opt/test.txt /opt/result.txt"
)

#
# @brief  Remove lines that contain words stored in a list
# @param  Value required string input and output file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# rm_lines "$IN_FILE" "$OUT_FILE"
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
function rm_lines {
    local IFILE=$1 OFILE=$2
    if [[ -n "${IFILE}" && -n "${OFILE}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Checking file [${IFILE}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_RM_LINES"
        if [ -f "${IFILE}" ]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_RM_LINES"
            local TMP1=/tmp/TMP.${RANDOM}$$
            trap 'rm -f $TMP1 >/dev/null 2>&1' 0
            trap "exit 1" 1 2 3 15
            sed -e 's/ //g' -e 's-^-/-g' -e 's-$-/d-' ${IFILE} > ${TMP1}
            sed -f "${TMP1}" "${OFILE}"
            info_debug_message_end "Done" "$FUNC" "$UTIL_RM_LINES"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_RM_LINES"
        MSG="Please check file [${IFILE}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_RM_LINES"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_RM_LINES"
        return $NOT_SUCCESS
    fi
    usage RM_LINES_USAGE
    return $NOT_SUCCESS
}

