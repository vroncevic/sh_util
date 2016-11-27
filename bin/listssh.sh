#!/bin/bash
#
# @brief   List SSH sessions
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LISTSSH=listssh
UTIL_LISTSSH_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_LISTSSH_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh

#
# @brief  List SSH sessions
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __listssh "$DIR_PATH"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # notify admin | user
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __listssh() {
    local TTY=$(tty | cut -f3- -d/)
    if [ -n "$TTY" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="List SSH sessions"
			printf "$DSTA" "$UTIL_LISTSSH" "$FUNC" "$MSG"
		fi
		PS_CMD="ps -o pid= -o command= -C sshd"
		GREP_CMD="grep sshd:.*@ | grep -v "@$TTY""
		SED_CMD="sed \"s/ sshd.*//\""
		eval "$PS_CMD | $GREP_CMD | $SED_CMD"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_LISTSSH" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    return $NOT_SUCCESS
}

