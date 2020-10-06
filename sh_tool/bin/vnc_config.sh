#!/bin/bash
#
# @brief   Generate Client VNC config file at /home/<username>/.vnc/
# @version ver.1.0.0
# @date    Sun Jun 14 16:08:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_VNC_CONFIG=vnc_config
UTIL_VNC_CONFIG_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_VNC_CONFIG_VERSION}
UTIL_VNC_CONFIG_CFG=${UTIL}/conf/${UTIL_VNC_CONFIG}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A VNC_CONFIG_Usage=(
    [Usage_TOOL]="${UTIL_VNC_CONFIG}"
    [Usage_ARG1]="[VNC_STRUCT] System username and group"
    [Usage_EX_PRE]="# Example generating VNC config file"
    [Usage_EX]="${UTIL_VNC_CONFIG} rmuller ds"
)

#
# @brief  Generating VNC client config file at home dir
# @param  Value required structure (username and department)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A VNC_STRUCT=(
#    [UN]="vroncevic"
#    [DN]="vroncevic"
# )
#
# vnc_config VNC_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s) | missing user home dir
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function vnc_config {
    local -n VNC_STRUCT=$1
    local USR=${VNC_STRUCT[UN]} DEP=${VNC_STRUCT[DN]}
    if [[ -n "${USR}" && -n "${DEP}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_vnc_config=()
        load_util_conf "$UTIL_VNC_CONFIG_CFG" config_vnc_config
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local UHOME="/home/${USR}"
            MSG="Checking directory [${UHOME}/]?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
            if [ -d "${UHOME}/" ]; then
                local VHOME="${UHOME}/.vnc"
                MSG="[ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
                MSG="Checking VNC configuration directory [${VHOME}/]?"
                info_debug_message_que "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
                if [ ! -d "${VHOME}/" ]; then
                    MSG="[not ok]"
                    info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
                    MSG="Create VNC configuration directory [${VHOME}/]!"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
                    mkdir "${VHOME}/"
                else
                    MSG="[ok]"
                    info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
                fi
                MSG="Generating VNC config file [$VHOME/xstartup]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
                local HASH="#" TAB="\t" VLINE
                while read VLINE
                do
                    eval echo -e "${VLINE}" >> "${VHOME}/xstartup"
                done < ${config_vnc_config[VNC_CONFIG_TEMPLATE]}
                MSG="Set owner!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
                eval "chown -R ${USR}.${DEP} ${VHOME}/"
                MSG="Set permission!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
                eval "chmod -R 755 ${VHOME}/"
                info_debug_message_end "Done" "$FUNC" "$UTIL_VNC_CONFIG"
                return $SUCCESS
            fi
            MSG="[not ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
            MSG="Please check directory [${UHOME}/]!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_VNC_CONFIG"
        return $NOT_SUCCESS
    fi
    usage VNC_CONFIG_Usage
    return $NOT_SUCCESS
}

