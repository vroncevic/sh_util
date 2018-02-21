#!/bin/bash
#
# @brief   Generate client SSH config file at home
# @version ver.1.0
# @date    Mon Jun 07 21:12:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SSH_CONFIG=ssh_config
UTIL_SSH_CONFIG_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_SSH_CONFIG_VERSION}
UTIL_SSH_CONFIG_CFG=${UTIL}/conf/${UTIL_SSH_CONFIG}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A MAKE_SSH_CONFIG_USAGE=(
    [USAGE_TOOL]="__${UTIL_SSH_CONFIG}"
    [USAGE_ARG1]="[USR] System username"
    [USAGE_ARG2]="[DEP] System group"
    [USAGE_EX_PRE]="# Generate SSH configuration"
    [USAGE_EX]="__${UTIL_SSH_CONFIG} vroncevic users"
)

#
# @brief  Generating SSH client config file at home
# @params Values required username and department
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# ssh_config "vroncevic" "vroncevic"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s) | check home dir
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function ssh_config {
    local USR=$1 DEP=$2
    if [[ -n "${USR}" && -n "${DEP}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_ssh_config=()
        load_util_conf "$UTIL_SSH_CONFIG_CFG" config_ssh_config
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            MSG="Generating SSH client config file at ${USR} home!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
            local UHOME="/home/${USR}"
            MSG="Checking user home directory [${UHOME}/]?"
            if [ -d "${UHOME}/" ]; then
                MSG="[ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
                MSG="Checking directory [${UHOME}/.ssh/]?"
                info_debug_message_que "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
                if [ ! -d "${UHOME}/.ssh/" ]; then
                    MSG="[not ok]"
                    info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
                    MSG="Creating directory [${UHOME}/.ssh/]!"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
                    mkdir "${UHOME}/.ssh/"
                fi
                MSG="[ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
                MSG="Generating SSH config file [${UHOME}/.ssh/config]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
                local SLINE HASH="#" TAB="\t"
                while read SLINE
                do
                    eval echo -e "$SLINE" >> "${UHOME}/.ssh/config"
                done < ${config_ssh_config[SSH_TEMPLATE]}
                MSG="Set owner!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
                eval "chown -R ${USR}.${DEP} ${UHOME}/.ssh/"
                MSG="Set permission!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
                chmod -R 700 "${UHOME}/.ssh/"
                info_debug_message_end "Done" "$FUNC" "$UTIL_SSH_CONFIG"
                return $SUCCESS
            fi
            MSG="[not ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
            MSG="Please check directory [${UHOME}/]!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_SSH_CONFIG"
        return $NOT_SUCCESS
    fi
    usage MAKE_SSH_CONFIG_USAGE
    return $NOT_SUCCESS
}

