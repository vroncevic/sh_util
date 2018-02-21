#!/bin/bash
#
# @brief   List SSH sessions
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LIST_SSH=list_ssh
UTIL_LIST_SSH_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_LIST_SSH_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh

#
# @brief  List SSH sessions
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# list_ssh "$DIR_PATH"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # notify admin | user
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function list_ssh {
    local TTY=$(tty | cut -f3- -d/)
    if [ -n "${TTY}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" PSCMD GREPCMD SEDCMD
        MSG="List SSH sessions!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_LIST_SSH"
        PSCMD="ps -o pid= -o command= -C sshd"
        GREPCMD="grep sshd:.*@ | grep -v "@${TTY}""
        SEDCMD="sed \"s/ sshd.*//\""
        eval "${PSCMD} | ${GREPCMD} | ${SEDCMD}"
        info_debug_message_end "Done" "$FUNC" "$UTIL_LIST_SSH"
        return $SUCCESS
    fi
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$UTIL_LIST_SSH"
    return $NOT_SUCCESS
}

