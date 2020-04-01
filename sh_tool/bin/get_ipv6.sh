#!/bin/bash
#
# @brief   Get IPV6 logic address
# @version ver.1.0.0
# @date    Tue Jan 31 13:57:19 CET 2017
# @company None, free software to use 2017
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_GET_IPV6=get_ipv6
UTIL_GET_IPV6_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_GET_IPV6_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A GET_IPV6_USAGE=(
    [USAGE_TOOL]="${UTIL_GET_IPV6}"
    [USAGE_ARG1]="[INTERFACE] Interface name"
    [USAGE_ARG2]="[IPV6_ADDRESS] Variable for storing"
    [USAGE_EX_PRE]="# Example checking IPV6 logic address"
    [USAGE_EX]="${UTIL_GET_IPV6} \$INTERFACE IPADDR"
)

#
# @brief  Get IPV6 logic address
# @params Values required interface name and variable for storing
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local INTERFACE="eth0" STATUS
# get_ipv6 $INTERFACE IPADDR
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
function get_ipv6 {
    local INTER=$1
    if [ -n "${INTER}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" SHOWIP SEDCMD IP
        MSG="Get IPV6 logic address!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_GET_IPV6"
        SHOWIP="ip addr show dev ${INTER}"
        SEDCMD="sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d'"
        IP=$(eval "${SHOWIP} | ${SEDCMD}")
        if [ -n "$IP" ]; then
            eval "$2='$IP'"
            info_debug_message_end "Done" "$FUNC" "$UTIL_GET_IPV6"
            return $SUCCESS
        fi
        MSG="Failed to get IPV6 logic address from local host!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_GET_IPV6"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_GET_IPV6"
        return $NOT_SUCCESS
    fi
    usage GET_IPV6_USAGE
    return $NOT_SUCCESS
}

