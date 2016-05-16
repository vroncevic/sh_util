#!/bin/bash
#
# @brief   List SSH sessions
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=listssh
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
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
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __listssh() {
    TTY=$(tty | cut -f3- -d/)
    if [ -n "$TTY" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[List SSH sessions]"
		fi
        ps -o pid= -o command= -C sshd | grep sshd:.*@ | grep -v "@$TTY" | sed "s/ sshd.*//"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    return $NOT_SUCCESS
}

