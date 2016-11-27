#!/bin/bash
#
# @brief   Checking X Server instance 
# @version ver.1.0
# @date    Fri Okt 04 17:55:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CHECKX=checkx
UTIL_CHECKX_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_CHECKX_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh

declare -A CHECKX_USAGE=(
    [USAGE_TOOL]="__$UTIL_CHECKX"
    [USAGE_ARG1]="[XINIT] Instance of tool for running X session"
    [USAGE_EX_PRE]="# Example checking X Server"
    [USAGE_EX]="__$UTIL_CHECKX \"xinit\""
)

#
# @brief  Checking X Server
# @param  Value required name of init process
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkx "xinit"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | X server isn't running
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __checkx() {
    local X=$1
    if [ -n "$X" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking X Server on [$HOSTNAME]"
        	printf "$DQUE" "$UTIL_CHECKX" "$FUNC" "$MSG"
		fi
        local XINIT=$(ps aux | grep -q $X)
        if [ "$XINIT" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "%s\n" "[up and running]"
				printf "$DEND" "$UTIL_CHECKX" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "%s\n" "[down]"
		fi
		MSG="Please check X Server on [$HOSTNAME]"
		printf "$SEND" "$UTIL_CHECKX" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage CHECKX_USAGE
    return $NOT_SUCCESS
}

