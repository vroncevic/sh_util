#!/bin/bash
#
# @brief   Load App/Tool/Script configuration
# @version ver.1.0
# @date    Mon Sep 20 21:00:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_LOAD_CONF" ]; then
    readonly __SH_UTIL_LOAD_CONF=1

    UTIL_LOAD_CONF=load_conf
    UTIL_LOAD_CONF_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_LOAD_CONF_VERSION}
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/check_cfg.sh

    declare -A LOAD_CONF_USAGE=(
        [USAGE_TOOL]="${UTIL_LOAD_CONF}"
        [USAGE_ARG1]="[FILE] Path to config file"
        [Usage_ARG2]="[CONFIG] Hash structure for config"
        [USAGE_EX_PRE]="# Example load configuration"
        [USAGE_EX]="${UTIL_LOAD_CONF} \$FILE configuration"
    )

    #
    # @brief  Load App/Tool/Script configuration from file
    # @params Values required path to file and config array
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # local FILE="/opt/sometool.cfg" STATUS
    # declare -A configuration=()
    # load_conf $FILE configuration
    # STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # missing argument | missing file
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function load_conf {
        local FILE=$1 CONFIG=$2
        if [[ -z "${FILE}" || -z "${CONFIG}" ]]; then
            usage LOAD_CONF_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS KEY VALUE
        MSG="Loading App/Tool/Script configuration!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_LOAD_CONF"
        check_cfg "${FILE}"
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            IFS="="
            while read -r KEY VALUE
            do
                if [ "${KEY}" == "ADMIN_EMAIL" ]; then
                    eval "$CONFIG[${KEY}]=$(printf "'%s' " "${VALUE}")"
                fi
                if [ "${KEY}" == "DEBUGGING" ]; then
                    eval "$CONFIG[${KEY}]=$(printf "'%s' " "${VALUE}")"
                fi
                if [ "${KEY}" == "LOGGING" ]; then
                    eval "$CONFIG[${KEY}]=$(printf "'%s' " "${VALUE}")"
                fi
                if [ "${KEY}" == "EMAILING" ]; then
                    eval "$CONFIG[${KEY}]=$(printf "'%s' " "${VALUE}")"
                fi
            done < ${FILE}
            info_debug_message_end "Done" "$FUNC" "$UTIL_LOAD_CONF"
            return $SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_LOAD_CONF"
        return $NOT_SUCCESS
    }
fi
