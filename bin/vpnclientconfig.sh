#!/bin/bash
#
# @brief   Generate Client VPN config file at
#          /home/<username>/<company>/openvpn/
# @version ver.1.0
# @date    Mon Jun 07 21:12:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_VPNCLIENTCONFIG=vpnclientconfig
UTIL_VPNCLIENTCONFIG_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VPNCLIENTCONFIG_VERSION
UTIL_VPNCLIENTCONFIG_CFG=$UTIL/conf/$UTIL_VPNCLIENTCONFIG.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/devel.sh 

declare -A VPNCLIENTCONFIG_USAGE=(
    [TOOL]="__$UTIL_VPNCLIENTCONFIG"
    [ARG1]="[VPN_STRUCTURE] Username, group, first and last name"
    [EX-PRE]="# Generate openVPN configuration"
    [EX]="__$UTIL_VPNCLIENTCONFIG vroncevic users Vladimir Roncevic"
)

#
# @brief  Generating VPN client config file at home dir
# @param  Value required structure (username, department, first and last name)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A VPN_STRUCTURE=()
# VPN_STRUCTURE[UN]="vroncevic"
# VPN_STRUCTURE[DN]="vroncevic"
# VPN_STRUCTURE[FN]="Vladimir"
# VPN_STRUCTURE[LN]="Roncevic"
#
# __vpnclientconfig $VPN_STRUCTURE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | missing home structure
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __vpnclientconfig() {
	local VPN_STRUCTURE=$1
    local UNAME=${VPN_STRUCTURE[UN]}
    local DEPART=${VPN_STRUCTURE[DN]}
    local FIRSTNAME=${VPN_STRUCTURE[FN]}
    local LASTNAME=${VPN_STRUCTURE[LN]}
    if [ -n "$UNAME" ] && [ -n "$DEPART" ] && 
       [ -n "$FIRSTNAME" ] && [ -n "$LASTNAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A configvpnclientconfigutil=()
		__loadutilconf $UTIL_VPNCLIENTCONFIG_CFG configvpnclientconfigutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local USER_HOME="/home/$UNAME"
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking dir [$USER_HOME/]"
				printf "$DQUE" "$UTIL_VPNCLIENTCONFIG" "$FUNC" "$MSG"
			fi
			if [ -d "$USER_HOME/" ]; then
				printf "%s\n" "[ok]"
				local USER_VPN="$USER_HOME/$UTIL_FROM_COMPANY"
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Checking dir [$USER_VPN/]"
					printf "$DQUE" "$UTIL_VPNCLIENTCONFIG" "$FUNC" "$MSG"
				fi
				if [ ! -d "$USER_VPN/" ]; then
					if [ "$TOOL_DBG" == "true" ]; then                
						printf "%s\n" "[not ok]"
						MSG="Creating at home dir [$UTIL_FROM_COMPANY/]"
						printf "$DSTA" "$UTIL_VPNCLIENTCONFIG" "$FUNC" "$MSG"
					fi
					mkdir "$USER_VPN/"
				fi
				if [ "$TOOL_DBG" == "true" ]; then
					printf "%s\n" "[ok]"
					MSG="Checking dir [$USER_VPN/openvpn/]"
					printf "$DQUE" "$UTIL_VPNCLIENTCONFIG" "$FUNC" "$MSG"
				fi
				if [ ! -d "$USER_VPN/openvpn/" ]; then
					if [ "$TOOL_DBG" == "true" ]; then
						printf "%s\n" "[not ok]"
						MSG="Creating dir [$USER_VPN/openvpn/]"
						printf "$DSTA" "$UTIL_VPNCLIENTCONFIG" "$FUNC" "$MSG"
					fi
					mkdir "$USER_VPN/openvpn/"
				fi
				local co=$(echo $UTIL_FROM_COMPANY | tr '[:upper:]' '[:lower:]')
				if [ "$TOOL_DBG" == "true" ]; then
					printf "%s\n" "[ok]"
					MSG="Generating config file [$USER_VPN/openvpn/$co.ovpn]"
					printf "$DSTA" "$UTIL_VPNCLIENTCONFIG" "$FUNC" "$MSG"
				fi
				local VPN_FILE="
#
# NS Frobas IT
# VPN configuration NSFROBAS network
#
client
	auth-nocache
	dev tun
	proto ${configvpnclientconfigutil[PROTO]}
	cipher ${configvpnclientconfigutil[CIPHER]}
	comp-lzo
	resolv-retry infinite
	persist-key
	persist-tun
	remote ${configvpnclientconfigutil[VPN_SERVER]} ${configvpnclientconfigutil[VPN_PORT]}
	ca ${configvpnclientconfigutil[CA]}
	cert $FIRSTNAME.$LASTNAME.crt
	key $FIRSTNAME.$LASTNAME.key

	verb 3
	float 
"
				echo -e "$VPN_FILE" > "$USER_VPN/openvpn/$co.ovpn"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$UTIL_VPNCLIENTCONFIG" "$FUNC" "Set owner"
				fi
				local PRFX_CMD="chown -R" 
				local OWNER="$UNAME.$DEPART" 
				eval "$PRFX_CMD $OWNER \"$USER_HOME/$UTIL_FROM_COMPANY/\""
				if [ "$TOOL_DBG" == "true" ]; then            
					printf "$DSTA" "$UTIL_VPNCLIENTCONFIG" "$FUNC" "Set permission"
				fi
				chmod -R 700 "$USER_HOME/$UTIL_FROM_COMPANY/"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DEND" "$UTIL_VPNCLIENTCONFIG" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
			printf "%s\n" "[not ok]"
			MSG="Please check dir [$USER_HOME/]"
			printf "$SEND" "$UTIL_VPNCLIENTCONFIG" "$MSG"
			return $NOT_SUCCESS
		fi
    fi 
    __usage $VPNCLIENTCONFIG_USAGE
    return $NOT_SUCCESS
}

