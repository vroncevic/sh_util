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
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
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
	local MSG=""
	if [ "$TOOL_DBG" == "true" ]; then
		MSG="Remove files, dirs whose name is timestamp older than certain time"
		printf "$DSTA" "$UTIL_RMOLD" "$FUNC" "$MSG"
	fi
	LS_CMD="ls"
	GREP_CMD="grep '....-..-..-......'"
	XARG_CMD="xargs -I {} bash -c"
	BASH_CMD="[[ x{} < x$(date -d '3 days ago' +%Y-%m-%d-%H%M%S) ]]"
	RM_CMD="rm -rfv {}"
    eval "$LS_CMD | $GREP_CMD | $XARG_CMD \"$BASH_CMD && $RM_CMD\""
	if [ "$TOOL_DBG" == "true" ]; then
		printf "$DEND" "$UTIL_RMOLD" "$FUNC" "Done"
	fi
}
