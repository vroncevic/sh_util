#!/bin/bash
#
# @brief   Cut operations on files
# @version ver.1.0
# @date    Mon Jul 15 21:55:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CUT_OPERATIONS=cut_operations
UTIL_CUT_OPERATIONS_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_CUT_OPERATIONS_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A COLUMN_USAGE=(
    [USAGE_TOOL]="cut_columns"
    [USAGE_ARG1]="[CUT_STRUCT] Columns for cuting and path"
    [USAGE_EX_PRE]="# Example for cuting columns from file"
    [USAGE_EX]="cut_columns \$CUT_STRUCT"
)

declare -A CHARACTER_USAGE=(
    [USAGE_TOOL]="cut_chars"
    [USAGE_ARG1]="[CUT_STRUCT] Characters and path"
    [USAGE_EX_PRE]="# Example for cuting characters from file"
    [USAGE_EX]="cut_chars \$CUT_STRUCT"
)

#
# @brief  Display n-st field from a column delimited file
# @param  Value reuired structure columns (columns for cuting) and file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A CUT_STRUCT=(
#    [COL]=1,3,5
#    [FILE]="file.ini"
# )
#
# cut_columns CUT_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | wrong argument
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function cut_columns {
    local -n CUT_STRUCT=$1
    local COL=${CUT_STRUCT[COL]} FILE=${CUT_STRUCT[FILE]}
    if [[ -n "${COL}" && -n "${FILE}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Checking file [${FILE}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_CUT_OPERATIONS"
        if [[ -e "${FILE}" && -f "${FILE}" ]]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CUT_OPERATIONS"
            cut -d -f "${COL}" "${FILE}"
            info_debug_message_end "Done" "$FUNC" "$UTIL_CUT_OPERATIONS"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CUT_OPERATIONS"
        MSG="Please check file [${FILE}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_CUT_OPERATIONS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_CUT_OPERATIONS"
        return $NOT_SUCCESS
    fi
    usage COLUMN_USAGE
    return $NOT_SUCCESS
}

#
# @brief  Diplay characters of every line in a file
# @param  Value required structure chars (columns for cuting) and file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A CUT_STRUCT=(
#     [CHARS]=$chars
#     [FILE]=$file
# )
#
# cut_chars CUT_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | wrong argument
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function cut_chars {
    local -n CUT_STRUCT=$1
    local CHARS=${CUT_STRUCT[CHARS]} FILE=${CUT_STRUCT[FILE]}
    if [[ -n "${CHARS}" && -n "${FILE}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Checking file [${FILE}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_CUT_OPERATIONS"
        if [[ -e "${FILE}" && -f "${FILE}" ]]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CUT_OPERATIONS"
            cut -c "${CHARS}" "${FILE}"
            info_debug_message_end "Done" "$FUNC" "$UTIL_CUT_OPERATIONS"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CUT_OPERATIONS"
        MSG="Please check file [${FILE}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_CUT_OPERATIONS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_CUT_OPERATIONS"
        return $NOT_SUCCESS
    fi
    usage CHARACTER_USAGE
    return $NOT_SUCCESS
}

