#!/bin/bash
#
# @brief   Get IPV4 logic address
# @version ver.1.0.0
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

declare -A GET_IPV4_Usage=(
    [Usage_TOOL]="${UTIL_CHECK_IPV4}"
    [Usage_ARG1]="[INTERFACE] Interface name"
    [Usage_ARG2]="[IPV4_ADDRESS] Variabel for storing address"
    [Usage_EX_PRE]="# Example get IPV4 logic address"
    [Usage_EX]="${UTIL_CHECK_IPV4} \$INTERFACE IPADDR"
)

#
# @brief  Get IPV4 logic address
# @params Values required interface name and variable for storing
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local INTERFACE="eth0" IPADDR
# get_ipv4 $INTERFACE IPADDR
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
function get_ipv4 {
    local INTER=$1
    if [ -n "${INTER}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" SHOWIP SEDCMD IP
        MSG="Get IPV4 logic address!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_GET_IPV4"
        SHOWIP="ip addr show dev ${INTER}"
        SEDCMD="sed -e's/^.*inet \([^ ]*\)\/.*$/\1/;t;d'"
        IP=$(eval "${SHOWIP} | ${SEDCMD}")
        if [ -n "$IP" ]; then
            eval "$1='$IP'"
            info_debug_message_end "Done" "$FUNC" "$UTIL_GET_IPV4"
            return $SUCCESS
        fi
        MSG="Failed to get IPV4 address from local host!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_GET_IPV4"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_GET_IPV4"
        return $NOT_SUCCESS
    fi
    usage GET_IPV4_Usage
    return $NOT_SUCCESS
}

