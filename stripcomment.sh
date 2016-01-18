#!/bin/bash
#
# @brief   Strips out the comments (/* COMMENT */) in a C program
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=stripcomment
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL"
    [ARG1]="[FILE] Path to C code"
    [EX-PRE]="# Strips comments from C code"
    [EX]="__$TOOL /data/test.c"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Strips out the comments (/* COMMENT */) in a C program
# @argument Value required path to C code
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __stripcomment $FILE
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __stripcomment() {
    FILE=$1
    if [ -n "$FILE" ]; then
        if [ -f "$FILE" ]; then
            printf "%s" "Checking Code File "
            type=`file $1 | awk '{ print $2, $3, $4, $5 }'`
            correct_type="ASCII C program text"
            if [ "$type" != "$correct_type" ]; then
                printf "%s\n" "[not ok]"
                printf "%s\n" "This script works on C program files only"
                return $NOT_SUCCESS
            fi  
            printf "%s\n" "[ok]"
            sed '/^\/\*/d /.*\*\//d' $1
            printf "%s\n" "Done..."
            return $SUCCESS
        fi
        printf "%s\n" "File [$FILE] doesn't exist..."
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
