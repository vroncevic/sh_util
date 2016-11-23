#!/bin/bash
#
# @brief   Generate Client SSH config file at
#          /home/<username>/.ssh/config
# @version ver.1.0
# @date    Mon Jun 07 21:12:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_MAKESSHCONFIG=makesshconfig
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A MAKESSHCONFIG_USAGE=(
    [TOOL_NAME]="__$UTIL_MAKESSHCONFIG"
    [ARG1]="[USERNAME]   System username"
    [ARG2]="[DEPARTMENT] System group"
    [EX-PRE]="# Generate SSH configuration"
    [EX]="__$UTIL_MAKESSHCONFIG vroncevic users"	
)

#
# @brief  Generating SSH client config file at home dir
# @params Values required username and department
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __makesshconfig "vroncevic" "users"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | check home dir
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __makesshconfig() {
    local USERNAME=$1
    local DEPARTMENT=$2
    if [ -n "$USERNAME" ] && [ -n "$DEPARTMENT" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Generating SSH client config file at $USERNAME home dir"
			printf "$DSTA" "$UTIL_MAKESSHCONFIG" "$FUNC" "$MSG"
		fi
		local UHOME="/home/$USERNAME"
        if [ -d "$UHOME/" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="Checking dir [$UHOME/.ssh/]"
				printf "$DQUE" "$UTIL_MAKESSHCONFIG" "$FUNC" "$MSG"
			fi
            if [ ! -d "$UHOME/.ssh/" ]; then
				if [ "$TOOL_DBG" == "true" ]; then
		            printf "%s\n" "[not ok]"
		            MSG="Creating dir [$UHOME/.ssh/]"
					printf "$DSTA" "$UTIL_MAKESSHCONFIG" "$FUNC" "$MSG"
				fi
                mkdir "$UHOME/.ssh/"
            else
				if [ "$TOOL_DBG" == "true" ]; then
                	printf "%s\n" "[ok]"
				fi
				:
            fi
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="Generating SSH config file [$UHOME/.ssh/config]"
				printf "$DSTA" "$UTIL_MAKESSHCONFIG" "$FUNC" "$MSG"
			fi
            SSH_CONFIG_FILE="
#
# $UTIL_FROM_COMPANY IT
# SSH session to host1, host2
#

Host host1
    HostName host1
    Port 5555
    User $USERNAME
 
Host host2
    HostName host2
    Port 7777
    User $USERNAME
"
			echo -e "$SSH_CONFIG_FILE" > "$UHOME/.ssh/config"
			if [ "$TOOL_DBG" == "true" ]; then
            	printf "$DSTA" "$UTIL_MAKESSHCONFIG" "$FUNC" "Set owner"
			fi
            chown -R "$USERNAME.$DEPARTMENT" "$UHOME/.ssh/"
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "$DSTA" "$UTIL_MAKESSHCONFIG" "$FUNC" "Set permission"
			fi
            chmod -R 700 "$UHOME/.ssh/"
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "$DEND" "$UTIL_MAKESSHCONFIG" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi          
		MSG="Please check dir [$UHOME/]"
		printf "$SEND" "$UTIL_MAKESSHCONFIG" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage $MAKESSHCONFIG_USAGE
    return $NOT_SUCCESS
}

