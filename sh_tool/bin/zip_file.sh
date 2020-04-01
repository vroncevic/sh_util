#!/bin/bash
#
# @brief   Make a zip archive with single target file
# @version ver.1.0.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ZIP_FILE=zip_file
UTIL_ZIP_FILE_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_ZIP_FILE_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A ZIP_FILE_USAGE=(
    [USAGE_TOOL]="${UTIL_ZIP_FILE}"
    [USAGE_ARG1]="[FILE] Name of file"
    [USAGE_EX-PRE]="# Example zipping a file"
    [USAGE_EX]="${UTIL_ZIP_FILE} freshtool.txt"
)

#
# @brief  zip a single file
# @params Values required file(s)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# zip_file "$FILES"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function zip_file {
    shift $((${OPTIND} - 1))
    local FILES=$@
    if [ -n "${FILES}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" A HLR OPTIONS RM_INPUT=
        while getopts HLR OPTIONS
        do
            case ${OPTIONS} in
                r)  RM_INPUT=on
                    ;;
                \?) 
                    MSG="Wrong argument!"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_ZIP_FILE"
                    MSG="Force exit!"
                    info_debug_message_end "$MSG" "$FUNC" "$UTIL_ZIP_FILE"
                    return $NOT_SUCCESS
                    ;;
            esac
        done
        for A in "${FILES[@]}"
        do
            if [ -f ${A}.[zZ][iI][pP] ] || [[ ${A##*.} == [zZ][iI][pP] ]]; then
                MSG="Skipping file [${A}] - already zipped!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_ZIP_FILE"
                continue
            else
                if [ ! -f "${A}" ]; then
                    MSG="File [${A}] does not exist!"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_ZIP_FILE"
                    continue
                fi
                MSG="Zipping file [${A}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_ZIP_FILE"
                zip -9 ${A}.zip ${A}
                [[ ${RM_INPUT} ]] && rm -f -- ${A}
            fi
        done
        info_debug_message_end "Done" "$FUNC" "$UTIL_ZIP_FILE"
        return $SUCCESS
    fi
    usage ZIP_FILE_USAGE
    return $NOT_SUCCESS
}

