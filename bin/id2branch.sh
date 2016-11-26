#!/bin/bash
#
# @brief   Convert id to branch
# @version ver.1.0
# @date    Mon Jul 15 21:22:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ID2BRANCH=id2branch
UTIL_ID2BRANCH_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_ID2BRANCH_VERSION
UTIL_ID2BRANCH_CFG=$UTIL/conf/$UTIL_ID2BRANCH.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/devel.sh

declare -A ID2BRANCH_USAGE=(
    ["TOOL"]="__$UTIL_ID2BRANCH"
    ["ARG1"]="[ID] Name of town or country"
    ["EX-PRE"]="# Example convert ns to ns-frobas-employee"
    ["EX"]="__$UTIL_ID2BRANCH \"ns\" BRANCH"	
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
# if [ $STATUS -eq $SUCCESS ]; then
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
		declare -A configid2branch=()
		__loadutilconf $UTIL_ID2BRANCH_CFG configid2branch
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
				MSG="Converting [$ID] to branch name"
				printf "$DSTA" "$UTIL_ID2BRANCH" "$FUNC" "$MSG"
			fi
			for K in "${!configid2branch[@]}"
			do
				if [ "$K" == "$ID" ]; then
					eval "$2=$(printf "'%s' " "${configid2branch[$K]}")"
					if [ "$TOOL_DEBUG" == "true" ]; then
						printf "$DEND" "$UTIL_ID2BRANCH" "$FUNC" "Done"
					fi
					return $SUCCESS
				fi
			done
			MSG="Please check ID [$ID]"
			printf "$SEND" "$UTIL_ID2BRANCH" "$MSG"
			return $NOT_SUCCESS
		fi
		return $NOT_SUCCESS
    fi
    __usage "$(declare -p ID2BRANCH_USAGE)"
    return $NOT_SUCCESS
}

