#!/bin/bash
#
# @brief   List opened files by specific user
# @version ver.1.0.0
# @date    Mon Oct 12 22:04:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LIST_OPEN_FILES=list_open_files
UTIL_LIST_OPEN_FILES_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_LIST_OPEN_FILES_VERSION}
UTIL_LIST_OPEN_FILES_CFG=${UTIL}/conf/${UTIL_LIST_OPEN_FILES}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A LIST_OPEN_FILES_USAGE=(
    [USAGE_TOOL]="${UTIL_LIST_OPEN_FILES}"
    [USAGE_ARG1]="[USR] System username"
    [USAGE_EX_PRE]="# Example list all opened files by user"
    [USAGE_EX]="${UTIL_LIST_OPEN_FILES} vroncevic"
)

#
# @brief  List opened files by specific user
# @param  Value required username
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local USR="vroncevic" STATUS
# list_open_files "$USR"
# STATUS=$?
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
function list_open_files {
    local USR=$1
    if [ -n "${USR}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_list_open_files=()
        load_util_conf "$UTIL_LIST_OPEN_FILES_CFG" config_list_open_files
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local LSOFCMD=${config_list_open_files[LSOF]}
            check_tool "${LSOFCMD}"
            STATUS=$?
            if [ $STATUS -eq $SUCCESS ];
                MSG="List opened files by [${USR}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_LIST_OPEN_FILES"
                eval "${LSOFCMD} -u ${USR}"
                info_debug_message_end "Done" "$FUNC" "$UTIL_LIST_OPEN_FILES"
                return $SUCCESS
            fi
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_LIST_OPEN_FILES"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_LIST_OPEN_FILES"
        return $NOT_SUCCESS
    fi
    usage LIST_OPEN_FILES_USAGE
    return $NOT_SUCCESS
}

