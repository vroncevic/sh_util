#!/bin/bash
#
# @brief   Check tool (does exist in system)
# @version ver.1.0
# @date    Mon Jul 15 20:57:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=checktool
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[TOOL_NAME] Name of App/Tool/Script"
    [EX-PRE]="# Example checking Java tool"
    [EX]="__$UTIL_NAME java"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Check tool (does exist and, is executable)
# @param  Value required App/Tool/Script name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checktool "$TOOL_NAME"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __checktool() {
    APP_TOOL_NAME=$1
    if [ -n "$APP_TOOL_NAME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Check tool (does exist in system)]"
        	printf "%s" "Checking tool [$APP_TOOL_NAME] "
		fi
        if [ -e "$APP_TOOL_NAME" ] && [ -x "$APP_TOOL_NAME" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "[ok]"
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi 
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[not ok]"
		fi
		LOG[MSG]="Check is tool [$APP_TOOL_NAME] installed"
		if [ "$TOOL_DEBUG" == "true" ]; then        
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

