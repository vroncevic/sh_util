#!/bin/bash
#
# @brief   Check root permission
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CHECKROOT=checkroot
UTIL_CHECKROOT_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_CHECKROOT_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh

# 
# @brief  Check root permission for current session
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkroot
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# you don't have root permission
#	# return $NOT_SUCCESS
#	# or
#	# exit 127
# fi
#
function __checkroot() {
	local FUNC=${FUNCNAME[0]}
	local MSG="None"
	if [ "$TOOL_DBG" == "true" ]; then
		MSG="Check permission for current session"
    	printf "$DQUE" "$UTIL_CHECKROOT" "$FUNC" "$MSG"
	fi
    if [ "$(id -u)" != "0" ] || [ "$EUID" -ne "$SUCCESS" ]; then
		if [ "$TOOL_DBG" == "true" ]; then
		    printf "%s\n" "[not ok]"
		fi
		MSG="Run App/Tool/Script as [root] user"
		printf "$SEND" "$UTIL_CHECKROOT" "$MSG"
        return $NOT_SUCCESS
    fi
	if [ "$TOOL_DBG" == "true" ]; then
    	printf "%s\n" "[ok]"
		printf "$DEND" "$UTIL_CHECKROOT" "$FUNC" "Done"
	fi
    return $SUCCESS
}

