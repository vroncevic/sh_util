#!/bin/bash
#
# @brief   Display an X window message when it's time to take a break
# @version ver.1.0.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_X_BREAK=x_break
UTIL_X_BREAK_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_X_BREAK_VERSION}
UTIL_X_BREAK_CFG=${UTIL}/conf/${UTIL_X_BREAK}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_x.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A X_BREAK_USAGE=(
    [USAGE_TOOL]="${UTIL_X_BREAK}"
    [USAGE_ARG1]="[TIME] Life time"
    [USAGE_EX_PRE]="# Example running tool"
    [USAGE_EX]="${UTIL_X_BREAK} 5s"
)

#
# @brief  Display an X window message when it's time to take a break
# @papram Value required time
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# x_break $TIME
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | wrong argument
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function x_break {
    local TIME=$1
    if [ -n "${TIME}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_x_break=()
        load_util_conf "$UTIL_X_BREAK_CFG" config_x_break
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local XINIT=${config_x_break[XINIT]} XMSG=${config_x_break[XMSG]}
            case ${TIME} in
                +([0-9]))
                    while :
                    do
                        check_x "${XMSG}"
                        STATUS=$?
                        if [ $STATUS -eq $SUCCESS ]; then
                            MSG="Time's up! Session will be closed!"
                            eval "${XMSG} -center ${MSG}"
                        else
                            MSG="Time's up! Session will be closed!"
                            info_debug_message "$MSG" "$FUNC" "$UTIL_X_BREAK"
                        fi
                    done 
                    info_debug_message_end "Done" "$FUNC" "$UTIL_X_BREAK"
                    return $SUCCESS
                    ;;
                *) 
                    usage X_BREAK_USAGE
                    ;;
            esac
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_X_BREAK"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_X_BREAK"
        return $NOT_SUCCESS
    fi
    usage X_BREAK_USAGE
    return $NOT_SUCCESS
}

