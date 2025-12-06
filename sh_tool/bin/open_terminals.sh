#!/bin/bash
#
# @brief   Opens n terminal windows
# @version ver.1.0
# @date    Tue Mar 03 16:58:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_OPEN_TERMINALS" ]; then
    readonly __SH_UTIL_OPEN_TERMINALS=1

    UTIL_OPEN_TERMINALS=open_terminals
    UTIL_OPEN_TERMINALS_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_OPEN_TERMINALS_VERSION}
    UTIL_OPEN_TERMINALS_CFG=${UTIL}/conf/${UTIL_OPEN_TERMINALS}.cfg
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/chec_tool.sh
    .    ${UTIL}/bin/load_util_conf.sh

    declare -A OPEN_TERMINALS_USAGE=(
        [USAGE_TOOL]="${UTIL_OPEN_TERMINALS}"
        [USAGE_ARG1]="[TERMS] number of terminal windows"
        [USAGE_EX_PRE]="# Open 4 terminal windows"
        [USAGE_EX]="${UTIL_OPEN_TERMINALS} 4"
    )

    #
    # @brief  Opens n terminal windows
    # @param  Value required number of terminal windows
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # open_terminals "$TERMS"
    # local STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # missing argument | missing tool
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function open_terminals {
        local TERMS=$1
        if [ -z "${TERMS}" ]; then
            usage OPEN_TERMINALS_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_open_terminals=()
        load_util_conf "$UTIL_OPEN_TERMINALS_CFG" config_open_terminals
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local TERM=${config_open_terminals[TERM]}
            MSG="Opens n terminal windows!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_OPEN_TERMINALS"
            __checktool "${TERM}"
            STATUS=$?
            if [ $STATUS -eq $SUCCESS ]; then
                local I=0
                while [ $I -lt $TERMS ]
                do
                    eval "${TERM} &"
                    I=$[$I+1]
                done
                info_debug_message_end "Done" "$FUNC" "$UTIL_OPEN_TERMINALS"
                return $SUCCESS
            fi
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_OPEN_TERMINALS"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_OPEN_TERMINALS"
        return $NOT_SUCCESS
    }
fi
