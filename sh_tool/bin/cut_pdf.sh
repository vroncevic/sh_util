#!/bin/bash
#
# @brief   Cut select pages from a pdf file, and create a new file
# @version ver.1.0.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CUT_PDF=cut_pdf
UTIL_CUT_PDF_VERSION=ver.1.0.0
UTIL=/root/scripts/sh_util/${UTIL_CUT_PDF_VERSION}
UTIL_CUT_PDF_CFG=${UTIL}/conf/${UTIL_CUT_PDF}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A CUT_PDF_Usage=(
    [USAGE_TOOL]="${UTIL_CUT_PDF}"
    [USAGE_ARG1]="[TIME] Life time"
    [USAGE_EX_PRE]="# Example running __${UTIL_CUT_PDF}"
    [USAGE_EX]="${UTIL_CUT_PDF} 5s"
)

#
# @brief  Cut select pages from a pdf file, and create a new file
# @param  Value required pdf structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A PDF_STRUCT=(
#    [INPUT]="/opt/green.pdf"
#    [OUTPUT]="/opt/green_stripped.pdf"
#    [FP]="12"
#    [LP]="23"
# )
#
# cut_pdf PDF_STRUCT
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
function cut_pdf {
    local -n PDF_STRUCT=$1
    local IPDF=${PDF_STRUCT[INPUT]} OPDF=${PDF_STRUCT[OUTPUT]}
    local FPAG=${PDF_STRUCT[FP]} LPAG=${PDF_STRUCT[LP]}
    if [[ -n "${IPDF}" && -n "${OPDF}" && -n "${FPAG}" && -n "${LPAG}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_cut_pdf=()
        load_util_conf "$UTIL_CUT_PDF_CFG" config_cut_pdf
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local PS2PDF=${config_cut_pdf[PS2PDF]}
            check_tool "${PS2PDF}"
            STATUS=$?
            if [ $STATUS -eq $SUCCESS ]; then
                MSG="Checking file [${IPDF}]?"
                info_debug_message_que "$MSG" "$FUNC" "$UTIL_CUT_PDF"
                if [ -e "${IPDF}" ]; then
                    MSG="[ok]"
                    info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CUT_PDF"
                    MSG="Cut pdf file [${IPDF}]!"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_CUT_PDF"
                    local FPAGE="-dFirstPage=$FPAG" LPAGE="-dLastPage=$LPAG"
                    eval "${PS2PDF} ${FPAGE} ${LPAGE} ${IPDF} ${OPDF}"
                    info_debug_message_end "Done" "$FUNC" "$UTIL_CUT_PDF"
                    return $SUCCESS
                fi
                MSG="[not ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CUT_PDF"
                MSG="Please check file [${IPDF}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_CUT_PDF"
                MSG="Force exit!"
                info_debug_message_end "$MSG" "$FUNC" "$UTIL_CUT_PDF"
                return $NOT_SUCCESS
            fi
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_CUT_PDF"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_CUT_PDF"
        return $NOT_SUCCESS
    fi
    usage CUT_PDF_Usage
    return $NOT_SUCCESS
}

