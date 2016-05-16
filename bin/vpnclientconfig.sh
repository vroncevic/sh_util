#!/bin/bash
#
# @brief   Generate Client VPN config file at
#          /home/<username>/company/openvpn/
# @version ver.1.0
# @date    Mon Jun 07 21:12:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=vpnclientconfig
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh 

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[VPN_STRUCTURE] Username, group, first and last name"
    [EX-PRE]="# Generate openvpn configuration"
    [EX]="__$UTIL_NAME \$VPN_STRUCTURE"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

COMPANY=company
PROTO=tcp
CIPHER=AES-128-CBC
VPN_SERVER=$COMPANY.com
VPN_PORT=1723
CA=$COMPANY.crt

#
# @brief  Generating VPN client config file at home dir
# @param  Value required structure (username, department, first and last name)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# VPN_STRUCTURE[UN]="vroncevic"
# VPN_STRUCTURE[DN]="it"
# VPN_STRUCTURE[FN]="Vladimir"
# VPN_STRUCTURE[LN]="Roncevic"
#
# __makevpnconfig $VPN_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __vpnclientconfig() {
    VPN_STRUCTURE=$1
    USERNAME=${VPN_STRUCTURE[UN]}
    DEPARTMENT=${VPN_STRUCTURE[DN]}
    FIRSTNAME=${VPN_STRUCTURE[FN]}
    LASTNAME=${VPN_STRUCTURE[LN]}
    if [ -n "$USERNAME" ] && [ -n "$DEPARTMENT" ] && [ -n "$FIRSTNAME" ] && [ -n "$LASTNAME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Generating VPN client config file at home dir]"
		fi
        if [ -d "/home/$USERNAME/" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s" "Checking directory [/home/$USERNAME/]"
			fi
            if [ ! -d "/home/$USERNAME/$COMPANY/" ]; then
				if [ "$TOOL_DEBUG" == "true" ]; then                
					printf "%s\n" "[not exist]"
                	printf "%s\n" "Creating frobas home directory"
				fi
                mkdir "/home/$USERNAME/$COMPANY/"
				if [ "$TOOL_DEBUG" == "true" ]; then                
					printf "%s\n" "Set owner"
				fi
                chown -R "$USERNAME.$DEPARTMENT" "/home/$USERNAME/$COMPANY/"
				if [ "$TOOL_DEBUG" == "true" ]; then                
					printf "%s\n" "Set permission"
				fi
                chmod -R 700 "/home/$USERNAME/$COMPANY/"
            fi
			if [ "$TOOL_DEBUG" == "true" ]; then
	            printf "%s\n" "[ok]"
	            printf "%s" "Checking openvpn directory "
			fi
            if [ ! -d "/home/$USERNAME/$COMPANY/openvpn/" ]; then
            	if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n" "[not exist]"
                	printf "%s\n" "Create openvon directory"
				fi
                mkdir "/home/$USERNAME/$COMPANY/openvpn/"
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "Set owner"
				fi
                chown -R "$USERNAME.$DEPARTMENT" "/home/$USERNAME/$COMPANY/openvpn/"
				if [ "$TOOL_DEBUG" == "true" ]; then                
					printf "%s\n" "Set permission"
				fi                
				chmod -R 700 "/home/$USERNAME/$COMPANY/openvpn/"
            fi
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "[ok]"
            	printf "%s\n" "Generating VPN config file [/home/$USERNAME/$COMPANY/openvpn/$COMPANY.ovpn]"
			fi
            cat<<EOF>>"/home/$USERNAME/$COMPANY/openvpn/$COMPANY.ovpn"
#
# NS $COMPANY IT
# VPN configuration $COMPANY network
#
client
	auth-nocache
	dev tun
	proto $PROTO
	cipher $CIPHER
	comp-lzo
	resolv-retry infinite
	persist-key
	persist-tun
	remote $VPN_SERVER $VPN_PORT
	ca $CA
	cert $FIRSTNAME.$LASTNAME.crt
	key $FIRSTNAME.$LASTNAME.key

	verb 3
	float 
 
EOF
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Set owner"
			fi
            chown -R "$USERNAME.$DEPARTMENT" "/home/$USERNAME/$COMPANY/openvpn/$COMPANY.ovpn"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "Set permission"
			fi
            chmod -R 700 "/home/$USERNAME/$COMPANY/openvpn/$COMPANY.ovpn"
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        else
            LOG[MSG]="Missing /home/$USERNAME/ directory"
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Error] ${LOG[MSG]}"
			fi
            __logging $LOG
            return $NOT_SUCCESS
        fi
    fi 
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

