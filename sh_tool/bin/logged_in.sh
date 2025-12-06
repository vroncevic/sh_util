#!/bin/bash
#
# @brief   Notify when a particular user has logged in
# @version ver.1.0
# @date    Fri Oct 16 20:47:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_LOGGED_IN" ]; then
    readonly __SH_UTIL_LOGGED_IN=1

    UTIL_LOGGED_IN=logged_in
    UTIL_LOGGED_IN_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_LOGGED_IN_VERSION}
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/usage.sh

    declare -A LOGGED_IN_USAGE=(
        [USAGE_TOOL]="${UTIL_LOGGED_IN}"
        [USAGE_ARG1]="[LOGIN_STRUCT] System username and time"
        [USAGE_EX_PRE]="# Create a file n bytes large"
        [USAGE_EX]="${UTIL_LOGGED_IN} \$LOGIN_STRUCT"
    )

    #
    # @brief  Notify when a particular user has logged in
    # @param  Value required structure username and time
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # declare -A LOGIN_STRUCT=(
    #     [USERNAME]="vroncevic"
    #     [TIME]=$time
    # )
    #
    # logged_in LOGIN_STRUCT
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
    function logged_in {
        local -n LOGIN_STRUCT=$1
        local USR=${LOGIN_STRUCT[USERNAME]} TIME=${LOGIN_STRUCT[TIME]}
        if [[ -z "${USR}" || -z "${TIME}" ]]; then
            usage LOGGED_IN_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Notify when a particular user [${USR}] has logged in!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_LOGGED_IN"
        who | grep "^${USR} " 2>&1 > /dev/null
        if [[ $? == 0 ]]; then
            MSG="User [${USR}] is logged in!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_LOGGED_IN"
            info_debug_message_end "Done" "$FUNC" "$UTIL_LOGGED_IN"
            return $SUCCESS
        fi
        until who | grep "^${USR}"
        do
            sleep ${TIME}
        done
        MSG="User [${USR}] just logged in!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_LOGGED_IN"
        info_debug_message_end "Done" "$FUNC" "$UTIL_LOGGED_IN"
        return $SUCCESS
    }
fi
