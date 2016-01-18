#!/bin/bash
#
# @brief   List all SSH sessions
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

SUCCESS=0
NOT_SUCCESS=1

#
# @brief List all SSH sessions
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __listssh $DIR_PATH
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __listssh() {
    TTY=$(tty | cut -f3- -d/)
    if [ -n "$TTY" ]; then
        ps -o pid= -o command= -C sshd | grep sshd:.*@ | grep -v "@$TTY" | sed "s/ sshd.*//"
        return $SUCCESS
    fi
    return $NOT_SUCCESS
}
