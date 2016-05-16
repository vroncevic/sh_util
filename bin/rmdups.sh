#!/bin/bash
#
# @brief   Remove duplicate lines from file or stdin
# @version ver.1.0
# @date    Sun Oct 04 22:28:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=rmdups
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[STREAM] stdin or file path"
    [EX-PRE]="# Remove duplicate lines from file or stdin"
    [EX]="__$UTIL_NAME /data/test.txt"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Remove duplicate lines from file or stdin
# @param  Value required stdin or file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __rmdups "$FILE_PATH"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __rmdups() {
    FILES=$@
    if [ -n "$FILES" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Remove duplicate lines from file or stdin]"
		fi
        if [ -f "$FILES" ]; then
            cat "${FILES[@]}" | { 
                awk '!x[$0]++'
            }
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
        LOG[MSG]="Check file(s) [$FILES]"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

