#!/bin/bash
#
# @brief   Notify when a particular user has logged in
# @version ver.1.0
# @date    Fri Oct 16 20:47:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LOGGEDIN=loggedin
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A LOGGEDIN_USAGE=(
    [TOOL_NAME]="__$UTIL_LOGGEDIN"
    [ARG1]="[LOGIN_STRUCTURE] System username and time"
    [EX-PRE]="# Create a file n bytes large"
    [EX]="__$UTIL_LOGGEDIN \$LOGIN_STRUCTURE"	
)

#
# @brief  Notify when a particular user has logged in
# @param  Value required structure username and time
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A LOGIN_STRUCTURE=()
# LOGIN_STRUCTURE[USERNAME]="rmuller"
# LOGIN_STRUCTURE[TIME]=$time
#
# __loggedin $LOGIN_STRUCTURE
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
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
function __loggedin() {
	local LOGIN_STRUCTURE=$1
    local USER_NAME=${LOGIN_STRUCTURE[USERNAME]}
    local TIME=${LOGIN_STRUCTURE[TIME]}
    if [ -n "$USER_NAME" ] && [ -n "$TIME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Notify when a particular user [$USER_NAME] has logged in"
			printf "$DSTA" "$UTIL_LOGGEDIN" "$FUNC" "$MSG"
		fi
        who | grep "^$USER_NAME " 2>&1 > /dev/null
        if [[ $? == 0 ]]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="User [$USER_NAME] is logged in"
				printf "$DSTA" "$UTIL_LOGGEDIN" "$FUNC" "$MSG"
				printf "$DEND" "$UTIL_LOGGEDIN" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
        until who | grep "^$USER_NAME "
        do
            sleep $TIME
        done
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="User [$USER_NAME] just logged in"
			printf "$DSTA" "$UTIL_LOGGEDIN" "$FUNC" "$MSG"
			printf "$DEND" "$UTIL_LOGGEDIN" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage $LOGGEDIN_USAGE
    return $NOT_SUCCESS
}

