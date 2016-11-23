#!/bin/bash
#
# @brief   Checking configuration file of App/Tool/Script
# @version ver.1.0
# @date    Wed Sep 16 10:22:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CHECKCFG=checkcfg
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A CHECKCFG_USAGE=(
    [TOOL_NAME]="__$UTIL_CHECKCFG"
    [ARG1]="[TOOL_CFG] Path to config file"
    [EX-PRE]="# Example checking config file"
    [EX]="__$UTIL_CHECKCFG /etc/sometool.cfg"	
)

#
# @brief  Checking configuration file exist/regular/noempty
# @param  Value required path to configuration file  
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local CFG_FILE="/opt/sometool.cfg"
# __checkcfg "$CFG_FILE"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
# 	# false
#	# missing argument | config file doesn't exist
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __checkcfg() {
    local CFG_FILE=$1
    if [ -n "$CFG_FILE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking configuration file [$CFG_FILE]"
        	printf "$DQUE" "$UTIL_CHECKCFG" "$FUNC" "$MSG"
		fi
        if [ -e "$CFG_FILE" ] && [ -f "$CFG_FILE" ] && [ -s "$CFG_FILE" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	printf "%s\n" "[ok]"
				printf "$DEND" "$UTIL_CHECKCFG" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
			printf "%s\n" "[not ok]"
		fi
		MSG="Please check config file [$CFG_FILE]"
		printf "$SEND" "$UTIL_CHECKCFG" "$MSG"
		return $NOT_SUCCESS
    fi
    __usage $CHECKCFG_USAGE
    return $NOT_SUCCESS
}

