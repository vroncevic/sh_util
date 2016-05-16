#!/bin/bash
#
# @brief   Notify when a particular user has logged out
# @version ver.1.0
# @date    Fri Oct 16 20:46:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=loggedout
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[LOGOUT_STRUCTURE] System username and time"
    [EX-PRE]="# Checking user to log out"
    [EX]="__$UTIL_NAME \$LOGOUT_STRUCTURE"	
)

#
# @brief  Notify when a particular user has logged out
# @param  Value required structure username and time
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# LOGOUT_STRUCTURE[USERNAME]="rmuller"
# LOGOUT_STRUCTURE[TIME]=$time
#
# __loggedout $LOGOUT_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __loggedout() {
	LOGOUT_STRUCTURE=$1
    USER_NAME=${LOGOUT_STRUCTURE[USERNAME]}
    TIME=${LOGOUT_STRUCTURE[TIME]}
    if [ -n "$USER_NAME" ] && [ -n "$TIME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[Notify when a particular user has logged out]"
		fi
        who | grep "^$1 " 2>&1 > /dev/null 
        if [[ $? != 0 ]]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "User [$USER_NAME] is not logged in"
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
        while who | grep "^$1 "; do
            sleep $TIME
        done
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "User [$USER_NAME] just logged out"
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

