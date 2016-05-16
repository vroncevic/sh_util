#!/bin/bash
#
# @brief   Checking configuration file of App/Tool/Script
# @version ver.1.0
# @date    Wed Sep 16 10:22:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=checkcfg
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[TOOL_CFG] Name of configuration file"
    [EX-PRE]="# Example checking CFG file"
    [EX]="__$UTIL_NAME /etc/test.cfg"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Check configuration file exist/regular/noempty
# @param  Value required path to configuration file  
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkcfg "$CFG_FILE"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __checkcfg() {
    CFG_FILE=$1
    if [ -n "$CFG_FILE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Checking configuration file of App/Tool/Script]"
        	printf "%s" "Checking CFG file [$CFG_FILE] "
		fi
        if [ -e "$CFG_FILE" ] && [ -f "$CFG_FILE" ] && [ -s "$CFG_FILE" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "[ok]"
				printf "%s\n" "[Done]"
			fi
            return $SUCCESS
        else
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "[not ok]"
			fi
			LOG[MSG]="Check file [$CFG_FILE]"
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Error] ${LOG[MSG]}"
			fi
            __logging $LOG
            return $NOT_SUCCESS
        fi
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

