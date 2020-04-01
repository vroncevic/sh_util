#!/bin/bash
#
# @brief   Converting avi to mp4 media format file
# @version ver.1.0.0
# @date    Tue Mar 03 17:56:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_AVI_TO_MP4=avi_to_mp4
UTIL_AVI_TO_MP4_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_AVI_TO_MP4_VERSION}
UTIL_AVI_TO_MP4_CFG=${UTIL}/conf/${UTIL_AVI_TO_MP4}.cfg
UTIL_LOG=$UTIL/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A AVI_TO_MP4_USAGE=(
    [USAGE_TOOL]="${UTIL_AVI_TO_MP4}"
    [USAGE_ARG1]="[FILE] Path to AVI file"
    [USAGE_EX_PRE]="# Example converting AVI file"
    [USAGE_EX]="${UTIL_AVI_TO_MP4} test.avi"
)

#
# @brief  Converting avi to mp4 media format file
# @param  Value required path of AVI file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local AVI="/home/vroncevic/Music/test.avi" STATUS
# avi_to_mp4 "$AVI"
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | failed to convert file
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function avi_to_mp4 {
    local FILE=$1
    if [ -n "${FILE}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_avi_to_mp4=()
        load_util_conf "$UTIL_AVI_TO_MP4_CFG" config_avi_to_mp4
        STATUS=$?
        MSG="Checking file [${FILE}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_AVI_TO_MP4"
        if [ -e "${FILE}" ]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_AVI_TO_MP4"
            local FFMPEG=${config_avi_to_mp4[FFMPEG]}
            check_tool "${FFMPEG}"
            STATUS=$?
            if [ $STATUS -eq $SUCCESS ]; then
                MSG="Converting [${FILE}] to MP4 format!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_AVI_TO_MP4"
                eval "${FFMPEG} -i \"${FILE}\" \"${FILE}.mp4\""
                MSG="Set owner!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_AVI_TO_MP4"
                local USRID=${config_avi_to_mp4[UID]}
                local GRPID=${config_avi_to_mp4[GID]}
                eval "chown ${USRID}.${GRPID} ${FILE}.mp4"
                info_debug_message_end "Done" "$FUNC" "$UTIL_AVI_TO_MP4"
                return $SUCCESS
            fi
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_AVI_TO_MP4"
            return $NOT_SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_AVI_TO_MP4"
        MSG="Please check file [${FILE}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_AVI_TO_MP4"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_AVI_TO_MP4"
        return $NOT_SUCCESS
    fi
    usage AVI_TO_MP4_USAGE
    return $NOT_SUCCESS
}

