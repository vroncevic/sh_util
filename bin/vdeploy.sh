#!/bin/bash
#
# @brief   Copy new version of tool to deployment zone
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_VDEPLOY=vdeploy
UTIL_VDEPLOY_VER=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_VDEPLOY_VER}
UTIL_VDEPLOY_CFG=${UTIL}/conf/${UTIL_VDEPLOY}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A VDEPLOY_USAGE=(
    [USAGE_TOOL]="__${UTIL_VDEPLOY}"
    [USAGE_ARG1]="[VDEPLOY_STRUCT] Version number and path to dev-dir"
    [USAGE_EX_PRE]="# Copy tool to deployment zone"
    [USAGE_EX]="__${UTIL_VDEPLOY} \$VDEPLOY_STRUCT"
)

#
# @brief  Copy new version of tool to deployment zone 
# @param  Value required, structure VDEPLOY_STRUCT
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A VDEPLOY_STRUCT=(
#    [TV]="ver.1.0"
#    [DP]="/opt/new_tool/"
# )
#
# vdeploy VDEPLOY_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s) | check dirs
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function vdeploy {
    local -n VDEPLOY_STRUCT=$1
    local VER=${VDEPLOY_STRUCT[TV]} DPATH=${VDEPLOY_STRUCT[DP]}
    if [[ -n "${VER}" && -n "${DPATH}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_vdeploy=()
        load_util_conf "$UTIL_VDEPLOY_CFG" config_vdeploy
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local SRC="${DPATH}/src" DIST="${DPATH}/dist"
            MSG="Checking directories [${SRC}/ver.${VER}.0/] [${DIST}/]?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_VDEPLOY"
            if [[ -d "${SRC}/ver.${VER}.0/" && -d "${DIST}/" ]]; then
                MSG="[ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VDEPLOY"
                MSG="Copy [${SRC}/ver.${VER}.0/] to [${DIST}/]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_VDEPLOY"
                cp -R "${SRC}/ver.${VER}.0/" "${DIST}/"
                MSG="Set owner!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_VDEPLOY"
                local UID=${config_vdeploy[UID]} GID=${config_vdeploy[GID]}
                eval "chown -R ${UID}.${GID} ${DIST}/"
                MSG="Set permission!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_VDEPLOY"
                eval "chmod -R 770 ${DIST}/"
                info_debug_message_end "Done" "$FUNC" "$UTIL_VDEPLOY"
                return $SUCCESS
            fi
            MSG="[not ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VDEPLOY"
            MSG="Please check directories [${SRC}/ver.${VER}.0/] [${DIST}/]!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_VDEPLOY"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_VDEPLOY"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_VDEPLOY"
        return $NOT_SUCCESS
    fi
    usage VDEPLOY_USAGE
    return $NOT_SUCCESS
}

