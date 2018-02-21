#!/bin/bash
#
# @brief   Copy tool to folder destination
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_X_COPY=x_copy
UTIL_X_COPY_VER=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_X_COPY_VER}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A X_COPY_USAGE=(
    [USAGE_TOOL]="__${UTIL_X_COPY}"
    [USAGE_ARG1]="[XCOPY_STRUCT] Tool name, version, path and dev-path"
    [USAGE_EX_PRE]="# Copy tool to folder destination"
    [USAGE_EX]="__${UTIL_X_COPY} \$XCOPY_STRUCT"
)

#
# @brief  Copy tool to folder destination
# @param  Value required, structure XCOPY_STRUCT
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A XCOPY_STRUCT=(
#    [TN]="new_tool"
#    [TV]="ver.1.0"
#    [AP]="/usr/bin/local/"
#    [DP]="/opt/new_tool/"
# )
#
# x_copy XCOPY_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s) | check paths
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function x_copy {
    local -n XCOPY_STRUCT=$1
    local NAME=${XCOPY_STRUCT[TN]} VER=${XCOPY_STRUCT[TV]}
    local APATH=${XCOPY_STRUCT[AP]} DPATH=${XCOPY_STRUCT[DP]}
    if [[ -n "${NAME}" && -n "${VER}" && -n "${APATH}" && -n "${DPATH}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Checking directory [${APATH}/]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_X_COPY"
        if [ -d "${APATH}/" ]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_X_COPY"
        else 
            mkdir "${APATH}/"
            MSG="[created]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_X_COPY"
        fi
        local APPVERSION="${APATH}/${VER}"
        MSG="Checking directory [${DPATH}/]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_X_COPY"
        if [ -d "${DPATH}/" ]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_X_COPY"
            MSG="Checking directory [${APPVERSION}/]?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_X_COPY"
            if [ -d "${APPVERSION}/" ]; then
                MSG="[ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_X_COPY"
                MSG="Clean directory [${APPVERSION}/]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_X_COPY"
                rm -rf "${APPVERSION}/"
            else
                MSG="[not ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_X_COPY"
                MSG="[nothing to clean]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_X_COPY"
            fi
            MSG="Copy tool to destination [${APATH}/]"
            info_debug_message "$MSG" "$FUNC" "$UTIL_X_COPY"
            cp -R "${DPATH}/dist/ver.${VER}.0/" "${APATH}/"
            info_debug_message_end "Done" "$FUNC" "$UTIL_X_COPY"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_X_COPY"
        MSG="Please check directory [${DPATH}/]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_X_COPY"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_X_COPY"
        return $NOT_SUCCESS
    fi
    usage X_COPY_USAGE
    return $NOT_SUCCESS
}

