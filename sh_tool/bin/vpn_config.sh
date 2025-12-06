#!/bin/bash
#
# @brief   Generate Client VPN CFG file at /home/<username>/<company>/openvpn/
# @version ver.1.0
# @date    Mon Jun 07 21:12:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_VPN_CONFIG" ]; then
    readonly __SH_UTIL_VPN_CONFIG=1

    UTIL_VPN_CONFIG=vpn_config
    UTIL_VPN_CONFIG_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_VPN_CONFIG_VERSION}
    UTIL_VPN_CONFIG_CFG=${UTIL}/conf/${UTIL_VPN_CONFIG}.cfg
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/load_util_conf.sh

    declare -A VPN_CONFIG_USAGE=(
        [USAGE_TOOL]="${UTIL_VPN_CONFIG}"
        [USAGE_ARG1]="[VPN_STRUCT] Username, group, first and last name"
        [USAGE_EX_PRE]="# Generate openVPN configuration"
        [USAGE_EX]="${UTIL_VPN_CONFIG} \$VPN_STRUCT"
    )

    #
    # @brief  Generating VPN client config file at home dir
    # @param  Value required structure (username, department, first and last name)
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # declare -A VPN_STRUCT=(
    #    [UN]="vroncevic"
    #    [DN]="vroncevic"
    #    [FN]="Vladimir"
    #    [LN]="Roncevic"
    # )
    #
    # vpn_config VPN_STRUCT
    # local STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # missing argument(s) | missing home structure
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function vpn_config {
        local -n VPN_STRUCT=$1
        local USR=${VPN_STRUCT[UN]} DEP=${VPN_STRUCT[DN]}
        local FNAME=${VPN_STRUCT[FN]} LNAME=${VPN_STRUCT[LN]}
        if [[ -z "${USR}" || -z "${DEP}" || -z "${FNAME}" || -z "${LNAME}" ]]; then
            usage VPN_CONFIG_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_vpn_config=()
        load_util_conf "$UTIL_VPN_CONFIG_CFG" config_vpn_config
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local UHOME="/home/${USR}"
            MSG="Checking directory [${UHOME}/]?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
            if [ -d "${UHOME}/" ]; then
                MSG="[ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
                local UVPN="${UHOME}/${UTIL_FROM_COMPANY}"
                MSG="Checking directory [${UVPN}/]?"
                info_debug_message_que "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
                if [ ! -d "$UVPN/" ]; then
                    MSG="[not ok]"
                    info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
                    MSG="Creating at home directory [${UTIL_FROM_COMPANY}/]!"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
                    mkdir "${UVPN}/"
                fi
                MSG="[ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
                MSG="Checking dir [${UVPN}/openvpn/]?"
                info_debug_message_que "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
                if [ ! -d "${UVPN}/openvpn/" ]; then
                    MSG="[not ok]"
                    info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
                    MSG="Creating dir [${UVPN}/openvpn/]!"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
                    mkdir "${UVPN}/openvpn/"
                fi
                local CO=$(echo $UTIL_FROM_COMPANY | tr '[:upper:]' '[:lower:]')
                MSG="[ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
                MSG="Generating config file [${UVPN}/openvpn/${CO}.ovpn]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
                local HASH="#" TAB="\t" ILINE OWNER="${USR}.${DEP}"
                while read ILINE
                do
                    eval echo -e "${ILINE}" >> "${UVPN}/openvpn/${CO}.ovpn"
                done < ${config_vpn_config[VPN_CONFIG_TEMPLATE]}
                MSG="Set owner!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
                eval "chown -R $OWNER \"${UHOME}/${UTIL_FROM_COMPANY}/\""
                MSG="Set permission!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
                eval "chmod -R 700 ${UHOME}/${UTIL_FROM_COMPANY}/"
                info_debug_message_end "Done" "$FUNC" "$UTIL_VPN_CONFIG"
                return $SUCCESS
            fi
            MSG="[not ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
            MSG="Please check directory [${UHOME}/]"
            info_debug_message "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_VPN_CONFIG"
        return $NOT_SUCCESS
    }
fi
