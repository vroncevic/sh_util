#!/bin/bash
#
# @brief   Inserting password
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_INSERTINGPASSWD=insertingpasswd
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
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __insertingpasswd() {
    local PASSWD="$1"
    local TMP_PASSWD=""
    local MSG=""
    local FUNC=${FUNCNAME[0]}
    stty -echo
    printf "%s" "Enter password: "
    read TMP_PASSWD
    eval "$PASSWD=$TMP_PASSWD"
    stty echo
    if [ -n "$PASSWD" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "$DEND" "$UTIL_INSERTINGPASSWD" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
	MSG="Empty password"
	printf "$SEND" "$UTIL_INSERTINGPASSWD" "$MSG"
    return $NOT_SUCCESS
}

