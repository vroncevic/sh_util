#!/bin/bash
#
# @brief   Notify when a particular user has logged out
# @version ver.1.0
# @date    Fri Oct 16 20:46:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LOGGEDOUT=loggedout
UTIL_LOGGEDOUT_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_LOGGEDOUT_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A LOGGEDOUT_USAGE=(
    [TOOL]="__$UTIL_LOGGEDOUT"
    [ARG1]="[LOGOUT_STRUCTURE] System username and time"
    [EX-PRE]="# Checking user to log out"
    [EX]="__$UTIL_LOGGEDOUT \$LOGOUT_STRUCTURE"	
)

#
# @brief  Notify when a particular user has logged out
# @param  Value required structure username and time
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A LOGOUT_STRUCTURE=()
# LOGOUT_STRUCTURE[USERNAME]="vroncevic"
# LOGOUT_STRUCTURE[TIME]=$time
#
# __loggedout $LOGOUT_STRUCTURE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __loggedout() {
	local LOGOUT_STRUCTURE=$1
    local USER_NAME=${LOGOUT_STRUCTURE[USERNAME]}
    local TIME=${LOGOUT_STRUCTURE[TIME]}
    if [ -n "$USER_NAME" ] && [ -n "$TIME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Notify when a particular user has logged out"
			printf "$DQUE" "$UTIL_LOGGEDOUT" "$FUNC" "$MSG"
		fi
        who | grep "^$1 " 2>&1 > /dev/null 
        if [[ $? != 0 ]]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="User [$USER_NAME] is not logged in"
				printf "$DQUE" "$UTIL_LOGGEDOUT" "$FUNC" "$MSG"
				printf "$DEND" "$UTIL_LOGGEDOUT" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
        while who | grep "^$1 "; do
            sleep $TIME
        done
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="User [$USER_NAME] just logged out"
			printf "$DQUE" "$UTIL_LOGGEDOUT" "$FUNC" "$MSG"
			printf "$DEND" "$UTIL_LOGGEDOUT" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage $LOGGEDOUT_USAGE
    return $NOT_SUCCESS
}

