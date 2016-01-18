#!/bin/bash
#
# @brief   Sort Copies
# @version ver.1.0
# @date    Mon Jul 15 22:48:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=sortcopy
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE_LCP=(
    [TOOL_NAME]="__lcp"
    [ARG1]="[EXSTENSION]  File extension."
    [ARG2]="[DESTINATION] Final destination for copy process"
    [EX-PRE]="# Copy all *.jpg files to directory /data/"
    [EX]="__lcp jpg /data/"	
)

declare -A TOOL_USAGE_DUP=(
    [TOOL_NAME]="__duplicatescounter"
    [ARG1]="[FILE_PATH] Sort and count duplicates"
    [EX-PRE]="# Sort and count duplicates"
    [EX]="__duplicatescounter /data/test.txt"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief List and copy files by extension
# @params Values required extension and destination
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __lcp jpg /data/
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __lcp() {
    EXSTENSION=$1
    DESTINATION=$2
    if [ -n "$DESTINATION" ] && [ -n "$DESTINATION" ]; then
        ls *.$EXSTENSION | xargs -n1 -i cp {} $DESTINATION
        return $SUCCESS
    fi
    __usage $TOOL_USAGE_LCP
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}


#
# @brief Count duplicates
# @argument Value required file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __duplicatescounter /data/test.txt
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __duplicatescounter() {
    FILE_PATH=$1
    if [ -n "$FILE_PATH" ]; then
        sort $FILE_PATH | uniq –c
        return $SUCCESS
    fi 
    __usage $TOOL_USAGE_DUP
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
