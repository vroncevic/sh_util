#!/bin/bash
#
# @brief   Display ms word doc file in ascii format
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_WORD_TO_TXT=word_to_txt
UTIL_WORD_TO_TXT_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_WORD_TO_TXT_VERSION}
UTIL_WORD_TO_TXT_CFG=${UTIL}/conf/${UTIL_WORD_TO_TXT}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A WORD_TO_TXT_USAGE=(
    [USAGE_TOOL]="__${UTIL_WORD_TO_TXT}"
    [USAGE_ARG1]="[DOC_FILE] Name of Document to be extracted"
    [USAGE_EX_PRE]="# Display ms word doc file in ascii format"
    [USAGE_EX]="__${UTIL_WORD_TO_TXT} test.doc"
)

#
# @brief  Display ms word doc file in ascii format
# @param  Value required name of document file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# word_to_txt "$DOC_FILE"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | missing tool
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function word_to_txt {
    local DOCFILES=$@
    if [ -n "${DOCFILES}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS A
        declare -A config_word_to_txt=()
        load_util_conf "$UTIL_WORD_TO_TXT_CFG" config_word_to_txt
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local CATDOC=${config_word_to_txt[CAT_DOC]}
            check_tool "${CATDOC}"
            STATUS=$?
            if [ $STATUS -eq $SUCCESS ]; then
                MSG="Extracting doc file [${DOCFILES}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_WORD_TO_TXT"
                for A in ${DOCFILES}
                do
                    if [ -f "${A}" ]; then
                        eval "${CATDOC} -b -s cp1252 -d 8859-1 -a ${A}"
                    else
                        MSG="Please check file [${A}]!"
                        info_debug_message "$MSG" "$FUNC" "$UTIL_WORD_TO_TXT"
                    fi
                done
                info_debug_message_end "Done" "$FUNC" "$UTIL_WORD_TO_TXT"
                return $SUCCESS
            fi
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_WORD_TO_TXT"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_WORD_TO_TXT"
        return $NOT_SUCCESS
    fi
    usage WORD_TO_TXT_USAGE
    return $NOT_SUCCESS
}

