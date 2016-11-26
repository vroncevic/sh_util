#!/bin/bash
#
# @brief   List opened files by specific user
# @version ver.1.0
# @date    Mon Oct 12 22:04:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LISTOPENFILES=listopenfiles
UTIL_LISTOPENFILES_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_LISTOPENFILES_VERSION
UTIL_LISTOPENFILES_CFG=$UTIL/conf/$UTIL_LISTOPENFILES.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A LISTOPENFILES_USAGE=(
    ["TOOL"]="__$UTIL_LISTOPENFILES"
    ["ARG1"]="[USER_NAME] System username"
    ["EX-PRE"]="# Example list all opened files by user"
    ["EX"]="__$UTIL_LISTOPENFILES vroncevic"
)

#
# @brief  List opened files by specific user
# @param  Value required username
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local USER_NAME="vroncevic"
# __listopenfiles "$USER_NAME"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __listopenfiles() {
    local USER_NAME=$1
    if [ -n "$USER_NAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A configlistopenfilesutil=()
		__loadutilconf "$UTIL_LISTOPENFILES_CFG" configlistopenfilesutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local lsofcmd=${configlistopenfilesutil[LSOF]}
			__checktool "$lsofcmd"
			STATUS=$?
			if [ $STATUS -eq $SUCCESS ];
				if [ "$TOOL_DBG" == "treu" ]; then
					MSG="List opened files by [$USER_NAME]"
					printf "$DSTA" "$UTIL_LISTOPENFILES" "$FUNC" "$MSG"
				fi
				eval "$lsofcmd -u $USER_NAME"
				if [ "$TOOL_DBG" == "treu" ]; then
					printf "$DEND" "$UTIL_LISTOPENFILES" "$FUNC" "Done"
				fi
				return $SUCCESS
		    fi
		    return $NOT_SUCCESS
		fi
		return $NOT_SUCCESS
    fi
    __usage "$(declare -p LISTOPENFILES_USAGE)"
    return $NOT_SUCCESS
}

