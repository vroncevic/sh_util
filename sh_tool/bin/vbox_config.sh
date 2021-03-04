#!/bin/bash
#
# @brief   Generate VBOX config files at /data/vm/vboxusers/<username>/
# @version ver.1.0.0
# @date    Wed Jun 5 13:58:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_VBOX_CONFIG=vbox_config
UTIL_VBOX_CONFIG_VERSION=ver.1.0.0
UTIL=/root/scripts/sh_util/${UTIL_VBOX_CONFIG_VERSION}
UTIL_CFG_VBOXCFG=${UTIL}/conf/${UTIL_VBOX_CONFIG}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A VBOX_CONFIG_Usage=(
    [USAGE_TOOL]="${UTIL_VBOX_CONFIG}"
    [USAGE_ARG1]="[USR] System username"
    [USAGE_EX_PRE]="# Example generating VBOX config files"
    [USAGE_EX]="${UTIL_VBOX_CONFIG} vroncevic"
)

#
# @brief  Generating VBOX client config files
# @param  Value required username (system username)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# vbox_config "vroncevic"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | check dirs
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function vbox_config {
    local USR=$1
    if [ -n "${USR}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_vbox_config=()
        load_util_conf "$UTIL_CFG_VBOXCFG" config_vbox_config
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local VBOXCONF=${config_vbox_config[VBOXCONF]}
            MSG="Checking directory [${VBOXCONF}/]?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
            if [ -d "${VBOXCONF}/" ]; then
                MSG="[ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
                local VBOXUSR="${VBOXCONF}/${USR}" BKPLIN VBOXUSRWIN
                MSG="Checking directory [${VBOXUSR}/]?"
                info_debug_message_que "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
                if [ ! -d "$VBOXUSR/" ]; then
                    MSG="[not ok]"
                    info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
                    MSG="Creating directory [${VBOXUSR}/]!"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
                    mkdir "${VBOXUSR}/"
                else
                    MSG="[ok]"
                    info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
                fi
                BKPLIN="${VBOXCONF}/${USR}/VirtualBox\ VMs/"
                cp -R "${BKPLIN}" "${VBOXUSR}/"
                VBOXUSRWIN="${VBOXCONF}/${USR}-win"
                MSG="Checking directory [${VBOXUSRWIN}/]?"
                info_debug_message_que "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
                if [ ! -d "${VBOXUSRWIN}/" ]; then
                    MSG="[not ok]"
                    info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
                    MSG="Creating directory [${VBOXUSRWIN}/]!"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
                    mkdir "${VBOXUSRWIN}/"
                else
                    MSG="[ok]"
                    info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
                fi
                local VBOX_USR=${config_vbox_config[VBOX_USR]} BKPWIN
                BKPWIN="${VBOX_USR}/$USR/VirtualBox\ VMs/"
                cp -R "${BKPWIN}" "${VBOXUSRWIN}/"
                info_debug_message_end "Done" "$FUNC" "$UTIL_VBOX_CONFIG"
                return $SUCCESS
            fi
            MSG="[not ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
            MSG="Please check directory [${VBOXCONF}/]!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_VBOX_CONFIG"
        return $NOT_SUCCESS
    fi
    usage VBOX_CONFIG_Usage
    return $NOT_SUCCESS
}

