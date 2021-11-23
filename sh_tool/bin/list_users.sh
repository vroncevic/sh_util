#!/bin/bash
#
# @brief   Print all common user names
# @version ver.1.0
# @date    Mon Oct 16 20:11:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LIST_USERS=list_users
UTIL_LIST_USERS_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_LIST_USERS_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A LIST_USERS_USAGE=(
    [USAGE_TOOL]="${UTIL_LIST_USERS}"
    [USAGE_ARG1]="[ID] Minimal user id"
    [USAGE_EX_PRE]="# Example print all common user names"
    [USAGE_EX]="${UTIL_LIST_USERS} 500"
)

#
# @brief  Print all common user names
# @param  Value required ID
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local ID=1000 STATUS
# list_users "$ID"
# STATUS=$?
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
function list_users {
    local ID=$1
    if [ -n "${ID}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Print all common user names started from id [${ID}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_LIST_USERS"
        awk -F: '$3 >= '${ID}' {print $1}' /etc/passwd
        info_debug_message_end "Done" "$FUNC" "$UTIL_LIST_USERS"
        return $SUCCESS
    fi
    usage LIST_USERS_USAGE
    return $NOT_SUCCESS
}

