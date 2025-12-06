#!/bin/bash
#
# @brief   Convert id to branch
# @version ver.1.0
# @date    Mon Jul 15 21:22:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_ID_TO_BRANCH" ]; then
    readonly __SH_UTIL_ID_TO_BRANCH=1

    UTIL_ID_TO_BRANCH=id_to_branch
    UTIL_ID_TO_BRANCH_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_ID_TO_BRANCH_VERSION}
    UTIL_ID_TO_BRANCH_CFG=${UTIL}/conf/${UTIL_ID_TO_BRANCH}.cfg
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/load_util_conf.sh

    declare -A ID_TO_BRANCH_USAGE=(
        [USAGE_TOOL]="${UTIL_ID_TO_BRANCH}"
        [USAGE_ARG1]="[ID] Name of town or country"
        [USAGE_EX_PRE]="# Example convert ns to ns-frobas-employee"
        [USAGE_EX]="${UTIL_ID_TO_BRANCH} \"ns\" BRANCH"
    )

    #
    # @brief  Convert id to branch
    # @params Values required id and branch
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # local ID="ns" BRANCH="" STATUS
    # id_to_branch $ID BRANCH
    # STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # missing argument | missing config file | missing id (branch)
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function id_to_branch {
        local ID=$1
        if [ -z "${ID}" ]; then
            usage ID_TO_BRANCH_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS K
        declare -A config_id_to_branch=()
        load_util_conf "$UTIL_ID_TO_BRANCH_CFG" config_id_to_branch
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            MSG="Converting [${ID}] to branch name!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_ID_TO_BRANCH"
            for K in "${!config_id_to_branch[@]}"
            do
                if [ "${K}" == "${ID}" ]; then
                    eval "$2=$(printf "'%s' " "${config_id_to_branch[${K}]}")"
                    info_debug_message_end "Done" "$FUNC" "$UTIL_ID_TO_BRANCH"
                    return $SUCCESS
                fi
            done
            MSG="Please check ID [${ID}]!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_ID_TO_BRANCH"
            MSG="Force exit"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_ID_TO_BRANCH"
            return $NOT_SUCCESS
        fi
        MSG="Force exit"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ID_TO_BRANCH"
        return $NOT_SUCCESS
    }
fi
