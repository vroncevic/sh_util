#!/bin/bash
#
# @brief   List target port
# @version ver.1.0
# @date    Mon Jun 02 21:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LISTPORT=listport
UTIL_LISTPORT_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_LISTPORT_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A LISTPORT_USAGE=(
    ["TOOL"]="__$UTIL_LISTPORT"
    ["ARG1"]="[PORT] Which you need to check"
    ["EX-PRE"]="# Example check port 1734"
    ["EX"]="__$UTIL_LISTPORT 1734"	
)

#
# @brief  Check port
# @param  Value required target port (port number)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __listport "1734"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __listport {
    local TARGET_PORT=$1
    if [ -n "$TARGET_PORT" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Checking port [$TARGET_PORT]"
			printf "$DSTA" "$UTIL_LISTPORT" "$FUNC" "$MSG"
		fi
        eval "netstat -lpdn | grep $TARGET_PORT"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_LISTPORT" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi 
    __usage "$(declare -p LISTPORT_USAGE)"
    return $NOT_SUCCESS
}

