#!/bin/bash
#
# @brief   List target port
# @version ver.1.0
# @date    Mon Jun 02 21:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LIST_PORTS=list_ports
UTIL_LIST_PORTS_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_LIST_PORTS_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A LIST_PORT_USAGE=(
    [USAGE_TOOL]="${UTIL_LIST_PORTS}"
    [USAGE_ARG1]="[PORT] Which you need to check"
    [USAGE_EX-PRE]="# Example check port 1734"
    [USAGE_EX]="${UTIL_LIST_PORTS} 1734"
)

#
# @brief  Check port
# @param  Value required target port (port number)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# list_ports "1734"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function list_ports {
    local PORT=$1
    if [ -n "${PORT}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Checking port [${PORT}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_LIST_PORTS"
        eval "netstat -lpdn | grep ${PORT}"
        info_debug_message "Done" "$FUNC" "$UTIL_LIST_PORTS"
        return $SUCCESS
    fi 
    usage LIST_PORT_USAGE
    return $NOT_SUCCESS
}

