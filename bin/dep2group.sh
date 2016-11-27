#!/bin/bash
#
# @brief   Convert name of department to group short name
# @version ver.1.0
# @date    Mon Jun 08 15:14:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_DEP2GROUP=dep2group
UTIL_DEP2GROUP_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_DEP2GROUP_VERSION
UTIL_DEP2GROUP_CFG=$UTIL/conf/$UTIL_DEP2GROUP.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/loadutilconf.sh

declare -A DEP2GROUP_USAGE=(
    [USAGE_TOOL]="__$UTIL_DEP2GROUP"
    [USAGE_ARG1]="[DEPARTMENT] Department name"
    [USAGE_EX_PRE]="# Example converting \"Management\" to \"me\""
    [USAGE_EX]="__$UTIL_DEP2GROUP \"Management\""
)

#
# @brief  Convert name of department to group
# @params Values required department name and group
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local GROUP=""
# local DEPARTMENT="Management"
# __dep2group $DEPARTMENT GROUP
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | missinf config file | failed to load config file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __dep2group() {
    local DEPARTMENT=$1
    if [ -n "$DEPARTMENT" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		declare -A configdep2group=()
		__loadutilconf $UTIL_DEP2GROUP_CFG configdep2group
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Convert name of department to group"
				printf "$DSTA" "$UTIL_DEP2GROUP" "$FUNC" "$MSG"
			fi
			for i in "${!configdep2group[@]}"
			do
				if [ "$DEPARTMENT" == "${configdep2group[$i]}" ]; then
					eval "$2=$(printf "'%s' " "$i")"
				fi
			done
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "$DEND" "$UTIL_DEP2GROUP" "$FUNC" "Done"
			fi
			return $SUCCESS
		fi
		return $NOT_SUCCESS
    fi
    __usage DEP2GROUP_USAGE
    return $NOT_SUCCESS
}

