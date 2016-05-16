#!/bin/bash
#
# @brief   Generate Client SSH config file at
#          /home/<username>/.ssh/config
# @version ver.1.0
# @date    Mon Jun 07 21:12:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=makesshconfig
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[USERNAME]   System username"
    [ARG2]="[DEPARTMENT] System group"
    [EX-PRE]="# Generate SSH configuration"
    [EX]="__$UTIL_NAME rmuller ds"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Generating SSH client config file at home dir
# @params Values required username and department
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __makesshconfig vroncevic it
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __makesshconfig() {
    USERNAME=$1
    DEPARTMENT=$2
    if [ -n "$USERNAME" ] && [ -n "$DEPARTMENT" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[Generating SSH client config file at home dir]"
		fi
        if [ -d "/home/$USERNAME/" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s" "Checking dir /home/$USERNAME/.ssh/ "
			fi
            if [ ! -d "/home/$USERNAME/.ssh/" ]; then
				if [ "$TOOL_DEBUG" == "true" ]; then
		            printf "%s\n" "[not ok]"
		            printf "%s\n" "Create SSH configuration directory"
				fi
                mkdir "/home/$USERNAME/.ssh/"
            else
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "[ok]"
				fi
				:
            fi
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Generating SSH config file [/home/$USERNAME/.ssh/config]"
			fi
            cat<<EOF>>"/home/$USERNAME/.ssh/config"
#
# NS Frobas IT
# SSH sessions
#

Host host1
    HostName host1comp
    Port 5000
    User $USERNAME
 
Host host2
    HostName host2comp
    Port 6000
    User $USERNAME

Host host3
    HostName host3comp
    Port 7000
    User $USERNAME
    
EOF
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Set owner"
			fi
            chown -R "$USERNAME.$DEPARTMENT" "/home/$USERNAME/.ssh/"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "Set permission"
			fi
            chmod -R 700 "/home/$USERNAME/.ssh/"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi 
        LOG[MSG]="Check home [/home/$USERNAME/]"
		if [ "$TOOL_DEBUG" == "true" ]; then            
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

