#!/bin/bash
#
# @brief   Run a local shell script on a remote server 
#          without copying it there
# @version ver.1.0
# @date    Tue Mar 03 21:44:32 2016
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SSHCMD=sshcmd
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A SSHCMD_USAGE=(
    [TOOL_NAME]="__$UTIL_SSHCMD"
    [ARG1]="[SSH_STRUCTURE] Username, server name and path to script"
    [EX-PRE]="# Example running script on remote server"
    [EX]="__$UTIL_SSHCMD \$SSH_STRUCTURE"	
)

#
# @brief  Run a local shell script on a remote server 
#         without copying it there
# @param  Value required SSH_STRUCTURE
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A SSH_STRUCTURE=() 
# SSH_STRUCTURE[UN]="rmuller"
# SSH_STRUCTURE[SN]="fronss1"
# SSH_STRUCTURE[SC]="test.sh"
#
# __sshcmd $SSH_STRUCTURE
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | missing script file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __sshcmd() {
    local SSH_STRUCTURE=$1
    local USER_NAME=${SSH_STRUCTURE[UN]}
    local SERVER_NAME=${SSH_STRUCTURE[SN]}
    local SCRIPT_NAME=${SSH_STRUCTURE[SC]}
    if [ -n "$USER_NAME" ] && [ -n "$SERVER_NAME" ] && 
	   [ -n "$SCRIPT_NAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking script file [$SCRIPT_NAME]"
			printf "$DQUE" "$UTIL_SSHCMD" "$FUNC" "$MSG"
		fi
        if [ -f "$SCRIPT_NAME" ]; then
            ssh $USER_NAME@$SERVER_NAME bash < $SCRIPT_NAME
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$UTIL_SSHCMD" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
        MSG="Check file [$SCRIPT_NAME]"
		printf "$SEND" "$UTIL_SSHCMD" "$MSG"
        return $NOT_SUCCESS
    fi
	__usage $SSHCMD_USAGE
	return $NOT_SUCCESS
}
