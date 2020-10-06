#!/bin/bash
#
# @brief   Notify when a particular user has logged out
# @version ver.1.0.0
# @date    Fri Oct 16 20:46:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LOGGED_OUT=logged_out
UTIL_LOGGED_OUT_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_LOGGED_OUT_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A LOGGED_OUT_Usage=(
    [Usage_TOOL]="${UTIL_LOGGED_OUT}"
    [Usage_ARG1]="[LOGOUT_STRUCT] System username and time"
    [Usage_EX_PRE]="# Checking user to log out"
    [Usage_EX]="${UTIL_LOGGED_OUT} \$LOGOUT_STRUCT"
)

#
# @brief  Notify when a particular user has logged out
# @param  Value required structure username and time
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A LOGOUT_STRUCT=(
#    [USERNAME]="vroncevic"
#    [TIME]=$time
# )
#
# logged_out LOGOUT_STRUCT
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
function logged_out {
    local -n LOGOUT_STRUCT=$1
    local USR=${LOGOUT_STRUCT[USERNAME]} TIME=${LOGOUT_STRUCT[TIME]}
    if [[ -n "${USR}" && -n "${TIME}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Notify when a particular user has logged out!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_LOGGED_OUT"
        who | grep "^${USR} " 2>&1 > /dev/null
        if [[ $? != 0 ]]; then
            MSG="User [${USR}] is not logged in!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_LOGGED_OUT"
            info_debug_message_end "Done" "$FUNC" "$UTIL_LOGGED_OUT"
            return $SUCCESS
        fi
        while who | grep "^${USR} "; do
            sleep ${TIME}
        done
        MSG="User [${USR}] just logged out!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_LOGGED_OUT"
        info_debug_message_end "Done" "$FUNC" "$UTIL_LOGGED_OUT"
        fi
        return $SUCCESS
    fi
    usage LOGGED_OUT_Usage
    return $NOT_SUCCESS
}

