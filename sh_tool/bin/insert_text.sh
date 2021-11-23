#!/bin/bash
#
# @brief   Insert text file into another file at line n
# @version ver.1.0
# @date    Mon Oct 01 08:41:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_INSERT_TEXT=insert_text
UTIL_INSERT_TEXT_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_INSERT_TEXT_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A INSERT_TEXT_USAGE=(
    [USAGE_TOOL]="${UTIL_INSERT_TEXT}"
    [USAGE_ARG1]="[LINE] A line number at which to insert the text file"
    [Usage_ARG2]="[TEXT] The text file to insert"
    [Usage_ARG3]="[FILES] The text file to insert into"
    [USAGE_EX_PRE]="# Example put text into file"
    [USAGE_EX]="${UTIL_INSERT_TEXT} 3 test file"
)

#
# @brief  Insert text file into another file at line n
# @params Values required line, text and files
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# insert_text $LINE $TEXT ${FILES[@]}
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s) | wrong argument
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function insert_text {
    local LINE=$1 TEXT=$2 FILES A N TMP1 TMP2
    shift 2
    FILES=$@
    if [[ -n "${LINE}" && -n "${TEXT}" && -n "${FILES}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Insert text file into another file at line n!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_INSERT_TEXT"
        TMP1=/tmp/tmp.${RANDOM}$$ TMP2=/tmp/tmp.${RANDOM}$$
        trap 'rm -f $TMP1 $TMP2 >/dev/null 2>&1' 0
        trap "exit 1" 1 2 3 15
        if [[ "${LINE}" == +([0-9]) ]]; then
            N=${LINE}
            for A in "${FILES[@]}"
            do
                if [ -f "${A}" ]; then
                    if [[ ${N} == 1 ]];then
                        touch "${TMP1}"
                        sed -n ''${N}',$p' "${A}" > "${TMP2}"
                        cat "${TMP1}" "${TEXT}" "${TMP2}" > "${A}"
                        continue
                    fi
                    ((N--))
                    sed -n '1,'${N}'p' "${A}" > "${TMP1}"
                    ((N++))
                    sed -n ''${N}',$p' "${A}" > "${TMP2}"
                    cat "${TMP1}" "${TEXT}" "${TMP2}" > "${A}"
                else
                    MSG="Check file [${A}]!"
                    info_debug_message_end "$MSG" "$FUNC" "$UTIL_INSERT_TEXT"
                fi
            done
        else
            MSG="Wrong argument!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_INSERT_TEXT"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_INSERT_TEXT"
            return $NOT_SUCCESS
        fi
        info_debug_message_end "Done" "$FUNC" "$UTIL_INSERT_TEXT"
        return $SUCCESS
    fi
    usage INSERT_TEXT_USAGE
    return $NOT_SUCCESS
}

