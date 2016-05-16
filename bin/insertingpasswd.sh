#!/bin/bash
#
# @brief   Inserting password
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=insertingpasswd
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh

#
# @brief  Inserting password
# @param  Value required password variable
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __insertingpasswd "$PASSWD"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __insertingpasswd() {
    PASSWD="$1"
    TMP_PASSWD=""
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n" "[Inserting password]"
	fi
    stty -echo
    printf "%s" "Enter password: "
    read TMP_PASSWD
    eval "$PASSWD=$TMP_PASSWD"
    stty echo
    if [ -n "$PASSWD" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n\n" "[Error] empty password"
	fi
    return $NOT_SUCCESS
}

