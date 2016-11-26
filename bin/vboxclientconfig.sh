#!/bin/bash
#
# @brief   Generate VBOX config files at
#          /data/vm/vboxusers/<username>/
# @version ver.1.0
# @date    Wed Jun 5 13:58:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_VBOXCLIENTCONFIG=vboxclientconfig
UTIL_VBOXCLIENTCONFIG_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VBOXCLIENTCONFIG_VERSION
UTIL_CFG_VBOXCFG=$UTIL/conf/$UTIL_VBOXCLIENTCONFIG.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/devel.sh

declare -A VBOXCLIENTCONFIG_USAGE=(
    ["TOOL"]="__$UTIL_VBOXCLIENTCONFIG"
    ["ARG1"]="[USERNAME] System username"
    ["EX-PRE"]="# Example generating VBOX config files"
    ["EX"]="__$UTIL_VBOXCLIENTCONFIG vroncevic"	
)

#
# @brief  Generating VBOX client config files
# @param  Value required username (system username)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __vboxclientconfig "vroncevic" 
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | check dirs
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __vboxclientconfig() {
    local USERNAME=$1
    if [ -n "$USERNAME" ]; then 
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A configvboxclientconfigutil=()
		__loadutilconf "$UTIL_CFG_VBOXCFG" configvboxclientconfigutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking dir [${configvboxclientconfigutil[VBOX_CONF]}/]"
				printf "$DQUE" "$UTIL_VBOXCLIENTCONFIG" "$FUNC" "$MSG"
			fi
			if [ -d "${configvboxclientconfigutil[VBOX_CONF]}/" ]; then
				printf "%s\n" "[ok]"
				local VBOX_USER="${configvboxclientconfigutil[VBOX_CONF]}/$USERNAME"
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Checking dir [$VBOX_USER/]"
					printf "$DQUE" "$UTIL_VBOXCLIENTCONFIG" "$FUNC" "$MSG"
				fi
				if [ ! -d "$VBOX_USER/" ]; then
					printf "%s\n" "[not ok]"
					if [ "$TOOL_DBG" == "true" ]; then
						MSG="Creating dir [$VBOX_USER/]"
						printf "$DSTA" "$UTIL_VBOXCLIENTCONFIG" "$FUNC" "$MSG"
					fi                
					mkdir "$VBOX_USER/"
				else
					printf "%s\n" "[ok]"
				fi
				local BKP_LIN="${configvboxclientconfigutil[VBOX_USR]}/$USERNAME/VirtualBox\ VMs/"
				cp -R "$BKP_LIN" "$VBOX_USER/"
				local VBOX_USER_WIN="${configvboxclientconfigutil[VBOX_CONF]}/${USERNAME}-win"
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Checking dir [$VBOX_USER_WIN/]"
					printf "$DQUE" "$UTIL_VBOXCLIENTCONFIG" "$FUNC" "$MSG"
				fi
				if [ ! -d "$VBOX_USER_WIN/" ]; then
					printf "%s\n" "[not ok]"
					if [ "$TOOL_DBG" == "true" ]; then
						MSG="Creating dir [$VBOX_USER_WIN/]"
						printf "$DSTA" "$UTIL_VBOXCLIENTCONFIG" "$FUNC" "$MSG"
					fi
					mkdir "$VBOX_USER_WIN/"
				else
					printf "%s\n" "[ok]"
 				fi
 				local BKP_WIN="${configvboxclientconfigutil[VBOX_USR]}/$USERNAME/VirtualBox\ VMs/"
 				cp -R "$BKP_WIN" "$VBOX_USER_WIN/"
				if [ "$TOOL_DBG" == "true" ]; then                
					printf "$DEND" "$UTIL_VBOXCLIENTCONFIG" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
			printf "%s\n" "[not ok]"
			MSG="Please check dir [$VBOX_CONF/]"
			printf "$SEND" "$UTIL_VBOXCLIENTCONFIG" "$MSG"
			return $NOT_SUCCESS
        fi
        return $NOT_SUCCESS
    fi 
    __usage "$(declare -p VBOXCLIENTCONFIG_USAGE)"
    return $NOT_SUCCESS
}

