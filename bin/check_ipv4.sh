#!/bin/bash
#
# @brief   Checking IPV4 Address
# @version ver.1.0
# @date    Sat Jan 28 13:29:22 CET 2017
# @company None, free software to use 2017
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_CHECK_IPV4=check_ipv4
UTIL_CHECK_IPV4_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_CHECK_IPV4_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A CHECK_IPV4_USAGE=(
    [USAGE_TOOL]="__${UTIL_CHECK_IPV4}"
    [USAGE_ARG1]="[IPV4_ADDRESS] Logic IPV4 Address"
    [USAGE_EX_PRE]="# Example checking IPV4 Address"
    [USAGE_EX]="__${UTIL_CHECK_IPV4} 192.168.0.1"
)

#
# @brief  Checking IPV4 Address
# @param  Value required ip address in ipv4 format
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local IP_ADDRESS="192.168.0.1" STATUS
# check_ipv4 "$IP_ADDRESS"
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | config file doesn't exist
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function check_ipv4 {
    local IPV4=$1
    if [ -n "${IPV4}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Checking IPV4 Address [${IPV4}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_CHECK_IPV4"
        if [[ $IPV4 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CHECK_IPV4"
            info_debug_message_end "Done" "$FUNC" "$UTIL_CHECK_IPV4"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CHECK_IPV4"
        MSG="Please provide IPV4 format [ex. 192.168.0.1]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_CHECK_IPV4"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_CHECK_IPV4"
        return $NOT_SUCCESS
    fi
    usage CHECK_IPV4_USAGE
    return $NOT_SUCCESS
}

