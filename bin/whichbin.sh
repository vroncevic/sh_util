#!/bin/bash
#
# @brief   Locate binary executable
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=whichbin
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[PATH] Path to destionation"
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
# @brief  Show links
# @param  Value required path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __follow_link "$PATH"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __follow_link() {
    SRC_FILE=$1
    FILE=$(which "$SRC_FILE")
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n" "[Show links]"
	fi
    if [ "$FILE" -eq "$NOT_SUCCESS" ]; then
		LOG[MSG]="[$FILE] not an executable"
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    if [ -L "$FILE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then        
			printf "%s\n" "Symbolic Link [$FILE]"
		fi
        cd $(dirname "$FILE")
        __follow_link $(set -- $(ls -l "$SRC_FILE"); shift 10; echo "$SRC_FILE")
    else
        ls -l $FILE
    fi
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n\n" "[Done]"
	fi
    return $SUCCESS
}

#
# @brief  Show links and path to executable
# @param  Value required path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __whichbin "$PATH"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __whichbin() {
    FILES=$@
    if [ -n "$FILES" ]; then 
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Show links and path to executable]"
		fi
        for a in ${FILES[@]}
        do
            __follow_link "$a"
        done 
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

