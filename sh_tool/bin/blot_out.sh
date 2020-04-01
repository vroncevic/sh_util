#!/bin/bash
#
# @brief   Blot out some file
# @version ver.1.0.0
# @date    Tue Oct 13 16:14:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_BLOT_OUT=blot_out
UTIL_BLOT_OUT_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_BLOT_OUT_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A BLOT_OUT_USAGE=(
    [USAGE_TOOL]="${UTIL_BLOT_OUT}"
    [USAGE_ARG1]="[FILE_NAME] Name of file"
    [USAGE_EX_PRE]="# Example delete file with high security"
    [USAGE_EX]="${UTIL_BLOT_OUT} /opt/test.ini"
)

#
# @brief  Blot out some file
# @param  Value required file name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# blot_out "$FILE_NAME"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | break | failed to delete file
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function blot_out {
    local FILE=$1
    if [ -n "${FILE}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" PASSES=7 BLOCKSIZE=1 ANSWER
        MSG="Checking file [${FILE}]?"
        info_debug_message_que "$MSG" "$FUNC" "${UTIL_BLOT_OUT}"
        if [ ! -e "${FILE}" ]; then
            MSG="[not ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_BLOT_OUT"
            MSG="Check file [${FILE}]!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_BLOT_OUT"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_BLOT_OUT"
            return $NOT_SUCCESS
        fi
        MSG="[ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_BLOT_OUT"
        MSG="Are you sure you want to blot out [${FILE}] (y/n)? "
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_BLOT_OUT"
        read ANSWER
        case "${ANSWER}" in
            [nN])
                MSG="Changed your mind!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_BLOT_OUT"
                MSG="Force exit!"
                info_debug_message_end "$MSG" "$FUNC" "$UTIL_BLOT_OUT"
                return $NOT_SUCCESS
                ;;
            *)
                MSG="Blotting out file [${FILE}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_BLOT_OUT"
                ;;
        esac
        local FLENGTH=$(ls -l "${FILE}" | awk '{print $5}') PASS_COUNT=1
        chmod u+w "${FILE}"
        while [ ${PASS_COUNT} -le ${PASSES} ]
        do
            printf "%s\n" "Pass #${PASS_COUNT}"
            sync
            dd if=/dev/urandom of=${FILE} bs=${BLOCKSIZE} count=${FLENGTH}
            sync
            dd if=/dev/zero of=${FILE} bs=${BLOCKSIZE} count=${FLENGTH}
            sync
            let "PASS_COUNT += 1"
        done
        rm -f "${FILE}"
        sync
        MSG="File [${FILE}] blotted out and deleted!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_BLOT_OUT"
        info_debug_message_end "Done" "$FUNC" "$UTIL_BLOT_OUT"
        return $SUCCESS
    fi
    usage BLOT_OUT_USAGE
    return $NOT_SUCCESS
}

