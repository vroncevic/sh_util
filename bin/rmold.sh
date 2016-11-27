#!/bin/bash
#
# @brief   Remove files and directories whose name is 
#          a timestamp older than a certain time
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_RMOLD=rmold
UTIL_RMOLD_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_RMOLD_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh

#
# @brief  Remove files and directories whose name is 
#         a timestamp older than a certain time
# @param  None
# @retval None
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __rmold
#
function __rmold() {
	local FUNC=${FUNCNAME[0]}
	local MSG="None"
	if [ "$TOOL_DBG" == "true" ]; then
		MSG="Remove files, dirs whose name is timestamp older than certain time"
		printf "$DSTA" "$UTIL_RMOLD" "$FUNC" "$MSG"
	fi
	local LS_CMD="ls"
	local GREP_CMD="grep '....-..-..-......'"
	local XARG_CMD="xargs -I {} bash -c"
	local BASH_CMD="[[ x{} < x$(date -d '3 days ago' +%Y-%m-%d-%H%M%S) ]]"
	local RM_CMD="rm -rfv {}"
    eval "$LS_CMD | $GREP_CMD | $XARG_CMD \"$BASH_CMD && $RM_CMD\""
	if [ "$TOOL_DBG" == "true" ]; then
		printf "$DEND" "$UTIL_RMOLD" "$FUNC" "Done"
	fi
}

