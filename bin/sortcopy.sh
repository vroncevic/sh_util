#!/bin/bash
#
# @brief   Sort Copies
# @version ver.1.0
# @date    Mon Jul 15 22:48:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=sortcopy
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE_LCP=(
    [TOOL_NAME]="__lcp"
    [ARG1]="[EXSTENSION]  File extension."
    [ARG2]="[DESTINATION] Final destination for copy process"
    [EX-PRE]="# Copy all *.jpg files to directory /opt/"
    [EX]="__lcp jpg /opt/"	
)

declare -A TOOL_USAGE_DUP=(
    [TOOL_NAME]="__duplicatescounter"
    [ARG1]="[FILE_PATH] Sort and count duplicates"
    [EX-PRE]="# Sort and count duplicates"
    [EX]="__duplicatescounter /opt/test.txt"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  List and copy files by extension
# @params Values required extension and destination
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __lcp "jpg" "/opt/"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __lcp() {
    EXSTENSION=$1
    DESTINATION=$2
    if [ -n "$DESTINATION" ] && [ -n "$DESTINATION" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[List and copy files by extension]"
			printf "%s" "Checking directory [$DESTINATION] "
		fi
        if [ -d "$DESTINATION" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "[ok]"
			fi
            ls *.$EXSTENSION | xargs -n1 -i cp {} "$DESTINATION"
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
        LOG[MSG]="Check destination [$DESTINATION]"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[not exist]"
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE_LCP
    return $NOT_SUCCESS
}


#
# @brief  Count duplicates
# @param  Value required file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __duplicatescounter "/opt/test.txt"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __duplicatescounter() {
    FILE_PATH=$1
    if [ -n "$FILE_PATH" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Count duplicates]"
			printf "%s" "Checking directory [$FILE_PATH] "
		fi
        if [ -d "$FILE_PATH" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "[ok]"
			fi
            sort "$FILE_PATH" | uniq -c
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
        LOG[MSG]="Check path [$FILE_PATH]"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[not exist]"
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi 
    __usage $TOOL_USAGE_DUP
    return $NOT_SUCCESS
}

