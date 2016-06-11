#!/bin/bash
#
# @brief   Convert id to branch
# @version ver.1.0
# @date    Mon Jul 15 21:22:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ID2BRANCH=id2branch
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_CFG_ID2BRANCH=$UTIL/conf/$UTIL_ID2BRANCH.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/devel.sh

declare -A ID2BRANCH_USAGE=(
    [TOOL_NAME]="__$UTIL_ID2BRANCH"
    [ARG1]="[ID] Name of town or country"
    [EX-PRE]="# Example convert ns to ns-frobas-employee"
    [EX]="__$UTIL_ID2BRANCH \"ns\" BRANCH"	
)

#
# @brief  Convert id to branch
# @params Values required id and branch
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local ID="ns"
# local BRANCH=""
# __id2branch $ID BRANCH
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | missing config file | missing id (branch)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __id2branch() {
    local ID=$1
    if [ -n "$ID" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A cfgid2branch=()
		__loadutilconf $UTIL_CFG_ID2BRANCH cfgid2branch
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
				MSG="Convert [$ID] to branch name"
				printf "$DSTA" "$UTIL_ID2BRANCH" "$FUNC" "$MSG"
			fi
			for K in "${!cfgid2branch[@]}"
			do
				if [ "$K" == "$ID" ]; then
					eval "$2=$(printf "'%s' " "${cfgid2branch[$K]}")"
					if [ "$TOOL_DEBUG" == "true" ]; then
						printf "$DEND" "$UTIL_ID2BRANCH" "$FUNC" "Done"
					fi
					return $SUCCESS
				fi
			done
			MSG="Check ID [$ID]"
			printf "$SEND" "$UTIL_ID2BRANCH" "$MSG"
			return $NOT_SUCCESS
		fi
		return $NOT_SUCCESS
    fi
    __usage $ID2BRANCH_USAGE
    return $NOT_SUCCESS
}
