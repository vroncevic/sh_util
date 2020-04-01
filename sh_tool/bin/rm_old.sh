#!/bin/bash
#
# @brief   Remove files and directories whose name is a timestamp
#          older than a certain time
# @version ver.1.0.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_RM_OLD=rm_old
UTIL_RM_OLD_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_RM_OLD_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh

#
# @brief   Remove files and directories whose name is a timestamp
#          older than a certain time
# @param  None
# @retval None
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# rm_old
#
function rm_old {
    local FUNC=${FUNCNAME[0]} MSG="None"
    MSG="Remove files, dirs whose name is timestamp older than certain time!"
    info_debug_message "$MSG" "$FUNC" "$UTIL_RM_OLD"
    local LS_CMD="ls" GREP_CMD="grep '....-..-..-......'"
    local XARG_CMD="xargs -I {} bash -c" RM_CMD="rm -rfv {}"
    local BASH_CMD="[[ x{} < x$(date -d '3 days ago' +%Y-%m-%d-%H%M%S) ]]"
    eval "$LS_CMD | $GREP_CMD | $XARG_CMD \"$BASH_CMD && $RM_CMD\""
    info_debug_message_end "Done" "$FUNC" "$UTIL_RM_OLD"
}

