#!/bin/bash
#
# @brief   Convert name of department to group short name
# @version ver.1.0.0
# @date    Mon Jun 08 15:14:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_DEP_TO_GROUP=dep_to_group
UTIL_DEP_TO_GROUP_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_DEP_TO_GROUP_VERSION}
UTIL_DEP_TO_GROUP_CFG=${UTIL}/conf/${UTIL_DEP_TO_GROUP}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A DEP_TO_GROUP_USAGE=(
    [USAGE_TOOL]="${UTIL_DEP_TO_GROUP}"
    [USAGE_ARG1]="[DEP] Department name"
    [USAGE_EX_PRE]="# Example converting \"Management\" to \"me\""
    [USAGE_EX]="${UTIL_DEP_TO_GROUP} \"Management\""
)

#
# @brief  Convert name of department to group
# @params Values required department name and group
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local DEP="Management" GROUP="" STATUS
# dep_to_group $DEP GROUP
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | missinf config file | failed to load config file
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function dep_to_group {
    local DEP=$1
    if [ -n "${DEP}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_dep_to_group=()
        load_util_conf "$UTIL_DEP_TO_GROUP_CFG" config_dep_to_group
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            MSG="Convert name of department to group!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_DEP_TO_GROUP"
            for i in "${!config_dep_to_group[@]}"
            do
                if [ "${DEP}" == "${config_dep_to_group[$i]}" ]; then
                    eval "$2=$(printf "'%s' " "$i")"
                fi
            done
            info_debug_message_end "Done" "$FUNC" "$UTIL_DEP_TO_GROUP"
            return $SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_DEP_TO_GROUP"
        return $NOT_SUCCESS
    fi
    usage DEP_TO_GROUP_USAGE
    return $NOT_SUCCESS
}

