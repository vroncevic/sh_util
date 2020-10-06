#!/bin/bash
#
# @brief   Load App/Tool/Script configuration
# @version ver.1.0.0
# @date    Mon Sep 20 21:00:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
#
UTIL_LOAD_CONF=load_conf
UTIL_LOAD_CONF_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_LOAD_CONF_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_cfg.sh

declare -A LOAD_CONF_Usage=(
    [Usage_TOOL]="${UTIL_LOAD_CONF}"
    [Usage_ARG1]="[FILE] Path to config file"
    [Usage_ARG2]="[CONFIG] Hash structure for config"
    [Usage_EX_PRE]="# Example load configuration"
    [Usage_EX]="${UTIL_LOAD_CONF} \$FILE configuration"
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
    if [[ -n "${FILE}" && -n "${CONFIG}" ]]; then
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
    fi
    usage LOAD_CONF_Usage
    return $NOT_SUCCESS
}

