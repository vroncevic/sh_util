#!/bin/bash
#
# @brief   Wrap text file at 80th column and replace file with the wrapped version
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=wraptext
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[PATH] Path to the target(s)"
    [EX-PRE]="# Example running __$UTIL_NAME"
    [EX]="__$UTIL_NAME /data/"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Wrap text file at 80th column and replace file with the wrapped version
# @param  Value required file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __wraptext "$FILES"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __wraptext() {
    FILES=$@
    if [ -n "$FILES" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Wrap text file at 80th column and replace file with the wrapped version]"
		fi
        for a in "${FILES[@]}"
        do
            if [ -f "$a" ]; then
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "Processing file [$a]"
				fi
                fmt -w 80 -s $a > /tmp/$$.tmp
                mv /tmp/$$.tmp $a
            else
				LOG[MSG]="Check file [$a]"
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n\n" "[Error] ${LOG[MSG]}"
				fi
                __logging $LOG
                return $NOT_SUCCESS
            fi
        done 
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

