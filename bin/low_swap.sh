#!/bin/bash
#
# @brief   Detecting low swap
# @version ver.1.0
# @date    Wed Sep 30 22:49:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LOW_SWAP=low_swap
UTIL_LOW_SWAP_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_LOW_SWAP_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/send_mail.sh

declare -A LOW_SWAP_USAGE=(
    [USAGE_TOOL]="__${UTIL_LOW_SWAP}"
    [USAGE_ARG1]="[LOW_LIMIT] An integer referring to MB"
    [USAGE_ARG2]="[EMAIL] Administrator email address"
    [USAGE_EX_PRE]="# Checking swap memory, is under 12 MB"
    [USAGE_EX]="__${UTIL_LOW_SWAP} 12 vladimir.roncevic@frobas.com"
)

#
# @brief  Notify when free swap memory is less then n Megabytes
# @params Values required count of MB and Admin email
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# low_swap "$MEM_LIMIT" "$EMAIL"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s) | wrong argument(s) | failed to send email
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function low_swap {
    local SWAPLIMIT=$1 EMAIL=$2
    if [[ -n "${SWAPLIMIT}" && -n "${EMAIL}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Checking swap memory, limit [${SWAPLIMIT}]!" STATUS SWAP_FREE
        info_debug_message "$MSG" "$FUNC" "$UTIL_LOW_SWAP"
        case ${SWAPLIMIT} in
            +([0-9]))
                SWAP_FREE=$(free -mo | grep Swap | { read a b c d; echo $d; })
                if [[ ${SWAP_FREE} < ${SWAPLIMIT} ]]; then
                    MSG="Swap is running low! Less then ${SWAPLIMIT} MB!"
                    send_mail "$MSG" "$EMAIL"
                    STATUS=$?
                    if [ $STATUS -eq $NOT_SUCCESS ]; then
                        MSG="Force exit!"
                        info_debug_message_end "$MSG" "$FUNC" "$UTIL_LOW_SWAP"
                        return $NOT_SUCCESS
                    fi
                    info_debug_message_end "Done" "$FUNC" "$UTIL_LOW_SWAP"
                    return $SUCCESS
                fi
                MSG="Swap memory ok!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_LOW_SWAP"
                info_debug_message_end "Done" "$FUNC" "$UTIL_LOW_SWAP"
                return $NOT_SUCCESS
                ;;
            *)
                MSG="Wrong argument"
                info_debug_message "$MSG" "$FUNC" "$UTIL_LOW_SWAP"
                MSG="Force exit!"
                info_debug_message_end "$MSG" "$FUNC" "$UTIL_LOW_SWAP"
                return $NOT_SUCCESS
                ;;
        esac
    fi
    usage LOW_SWAP_USAGE
    return $NOT_SUCCESS
}

