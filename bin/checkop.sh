#!/bin/bash
#
# @brief   Checking operation to be done
# @version ver.1.0
# @date    Thu Apr 28 20:40:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CHECKOP=checkop
UTIL_CHECKOP_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_CHECKOP_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh

declare -A CHECKOP_USAGE=(
    [USAGE_TOOL]="__$UTIL_CHECKOP"
    [USAGE_ARG1]="[OPERATION]      Operation to be done"
	[USAGE_ARG2]="[OPERATION_LIST] List of operations"
    [USAGE_EX_PRE]="# Example checking operation"
    [USAGE_EX]="__$UTIL_CHECKOP \"restart\" \"\${OPERATION_LIST[*]\""	
)

#
# @brief  Checking operation to be done
# @params Values required operation and list of operations
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local OPERATION="restart"
# local OPERATION_LIST=( start stop restart version )
#
# __checkop "$OPERATION" "${OPERATION_LIST[*]}"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
# 	# false
#	# missing argument | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __checkop() {
	local OPERATION=$1
	OPERATION_LIST=($2)
	if [ -n "$OPERATION" ] && [ -n "$OPERATION_LIST" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking operation [$OPERATION]"
			printf "$DQUE" "$UTIL_CHECKOP" "$FUNC" "$MSG"
		fi
		for i in "${OPERATION_LIST[@]}"
        do
			if [ "$OPERATION" == "$i" ]; then
				if [ "$TOOL_DBG" == "true" ]; then
					printf "%s\n" "[ok]"
					printf "$DEND" "$UTIL_CHECKOP" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
			:
		done
		if [ "$TOOL_DBG" == "true" ]; then
			printf "%s\n" "[not ok]"
		fi
		MSG="Please check operation [$OPERATION]"
		printf "$SEND" "$UTIL_CHECKOP" "$MSG"
		return $NOT_SUCCESS
	fi
	__usage CHECKOP_USAGE
	return $NOT_SUCCESS
}

