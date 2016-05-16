#!/bin/bash
#
# @brief   Run a local shell script on a remote server 
#          without copying it there
# @version ver.1.0
# @date    Tue Mar 03 21:44:32 2016
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=sshcmd
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[SSH_STRUCTURE] Username, server name and path to script"
    [EX-PRE]="# Example running script on remote server"
    [EX]="__$UTIL_NAME \$SSH_STRUCTURE"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
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
# SSH_STRUCTURE[UN]="rmuller"
# SSH_STRUCTURE[SN]="fronss1"
# SSH_STRUCTURE[SC]="test.sh"
#
# __sshcmd $SSH_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __sshcmd() {
    SSH_STRUCTURE=$1
    USER_NAME=${SSH_STRUCTURE[UN]}
    SERVER_NAME=${SSH_STRUCTURE[SN]}
    SCRIPT_NAME=${SSH_STRUCTURE[SC]}
    if [ -n "$USER_NAME" ] && [ -n "$SERVER_NAME" ] && [ -n "$SCRIPT_NAME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Run a local shell script on a remote server without copying it there]"
			printf "%s\n" "Checking script file [$SCRIPT_NAME]"
		fi
        if [ -f "$SCRIPT_NAME" ]; then
            ssh $USER_NAME@$SERVER_NAME bash < $SCRIPT_NAME
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
		LOG[MSG]="Check file [$SCRIPT_NAME]"
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    else
        __usage $TOOL_USAGE
        return $NOT_SUCCESS
    fi
}

