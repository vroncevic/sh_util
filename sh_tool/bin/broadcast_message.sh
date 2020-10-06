#!/bin/bash
#
# @brief   Broadcast messanger
# @version ver.1.0.0
# @date    Mon Nov 28 19:02:41 CET 2016
# @company None, free  software to use 2016
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
# 
UTIL_BROADCAST_BMSG=broadcast_message
UTIL_BROADCAST_BMSG_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_BROADCAST_BMSG_VERSION}
UTIL_BROADCAST_BMSG_CFG=${UTIL}/conf/${UTIL_BROADCAST_BMSG}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A BROADCAST_BMSG_Usage=(
    [Usage_TOOL]="${UTIL_BROADCAST_BMSG}"
    [Usage_ARG1]="[BMSG] Main message for broadcast"
    [Usage_ARG2]="[NOTE] Short note with fullname"
    [Usage_EX_PRE]="# Example sending broadcast message"
    [Usage_EX]="${UTIL_BROADCAST_BMSG} \$BM_STRUCTURE"
)

#
# @brief  Sending broadcast message
# @param  Value required broadcast_message structure (message and NOTE)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A BM_STRUCTURE=(
#    [BMSG]="Hi all, new git repository is up and running!"
#    [NOTE]="Best Regards, Vladimir Roncevic"
# )
#
# broadcast_message BM_STRUCTURE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s)
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function broadcast_message {
    local -n BM_STRUCT=$1
    local BMSG=${BM_STRUCT[BMSG]} NOTE=${BM_STRUCT[NOTE]}
    if [[ -n "${BMSG}" && -n "${NOTE}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Sending broadcast message!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_BROADCAST_BMSG"
        declare -A config_broadcast_message=()
        load_util_conf "$UTIL_BROADCAST_BMSG_CFG" config_broadcast_message
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local WALL MSG_TMP MSG_LINE
            WALL=${config_broadcast_message[WALL]}
            MSG_TMP=${config_broadcast_message[BMSG_TMP_FILE]}
            check_tool "${WALL}"
            STATUS=$?
            if [ $STATUS -eq $SUCCESS ]; then
                while read MSG_LINE
                do
                    eval echo "${MSG_LINE}" >> ${MSG_TMP}
                done < ${config_broadcast_message[BMSG_TEMPLATE]}
                eval "${WALL} < ${MSG_TMP}"
                rm -f "${MSG_TMP}"
                MSG="Sent broadcast message!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_BROADCAST_BMSG"
                info_debug_message_end "Done" "$FUNC" "$UTIL_BROADCAST_BMSG"
                return $SUCCESS
            fi
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_BROADCAST_BMSG"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_BROADCAST_BMSG"
        return $NOT_SUCCESS
    fi
    usage BROADCAST_BMSG_Usage
    return $NOT_SUCCESS
}

