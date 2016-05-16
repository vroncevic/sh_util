#!/bin/bash
#
# @brief   Notify when a particular user has logged in
# @version ver.1.0
# @date    Fri Oct 16 20:47:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=loggedin
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[LOGIN_STRUCTURE] System username and time"
    [EX-PRE]="# Create a file n bytes large"
    [EX]="__$UTIL_NAME \$LOGIN_STRUCTURE"	
)

#
# @brief  Notify when a particular user has logged in
# @param  Value required structure username and time
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# LOGIN_STRUCTURE[USERNAME]="rmuller"
# LOGIN_STRUCTURE[TIME]=$time
#
# __loggedin $LOGIN_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __loggedin() {
	LOGIN_STRUCTURE=$1
    USER_NAME=${LOGIN_STRUCTURE[USERNAME]}
    TIME=${LOGIN_STRUCTURE[TIME]}
    if [ -n "$USER_NAME" ] && [ -n "$TIME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Notify when a particular user has logged in]"
		fi
        who | grep "^$USER_NAME " 2>&1 > /dev/null
        if [[ $? == 0 ]]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "User [$USER_NAME] is logged in"
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
        until who | grep "^$USER_NAME "
        do
            sleep $TIME
        done
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "User [$USER_NAME] just logged in"
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

