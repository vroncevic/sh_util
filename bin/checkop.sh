#!/bin/bash
#
# @brief   Check operation to be done
# @version ver.1.0
# @date    Thu Apr 28 20:40:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=checkop
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[OPERATION]      Operation to be done"
	[ARG2]="[OPERATION_LIST] List of operations"
    [EX-PRE]="# Example checking operation"
    [EX]="__$UTIL_NAME \"restart\" \"\${OPERATION_LIST[*]\""	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Check operation
# @params Values required operation and list of operations
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# OPERATION="restart"
# OPERATION_LIST=( start stop restart version )
#
# __checkop "$OPERATION" "${OPERATION_LIST[*]}"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __checkop() {
	OPERATION=$1
	OPERATION_LIST=($2)
	if [ -n "$OPERATION" ] && [ -n "$OPERATION_LIST" ]; then
		for i in "${OPERATION_LIST[@]}"
        do
			if [ "$OPERATION" == "$i" ]; then
				return $SUCCESS
			fi
			:
		done
	fi
	return $NOT_SUCCESS
}

