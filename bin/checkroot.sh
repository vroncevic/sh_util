#!/bin/bash
#
# @brief   Check root permission
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=checkroot
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh

# 
# @brief  Check root permission
# @retval success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkroot
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __checkroot() {
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n" "[Check user]"
    	printf "%s" "Check permissions "
	fi
    if [ "$(id -u)" != "0" ] || [ "$EUID" -ne "$SUCCESS" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
		    printf "%s\n" "[not ok]"
		    printf "%s\n\n" "[Error] $USER, this App/Tool/Script must run as [root]"
		fi
        return $NOT_SUCCESS
    fi
	if [ "$TOOL_DEBUG" == "true" ]; then
    	printf "%s\n" "[ok]"
		printf "%s\n\n" "[Done]"
	fi
    return $SUCCESS
}

