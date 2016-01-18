#!/bin/bash
#
# @brief   Cut operations on files
# @version ver.1.0
# @date    Mon Jul 15 21:55:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=cutoperations
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE_COL=(
    [TOOL_NAME]="__cutcolumns"
    [ARG1]="[COLUMNS] Columns for cuting"
    [ARG2]="[FILE]    Path to file for cuting"
    [EX-PRE]="# Example for cuting columns from file"
    [EX]="__cutcolumns 1,3,5 file.ini"	
)

declare -A TOOL_USAGE_CHA=(
    [TOOL_NAME]="__cutchars"
    [ARG1]="[TOOL_NAME] Characters"
    [ARG2]="[FILE]      Path to file for cuting"
    [EX-PRE]="# Example for cuting characters from file"
    [EX]="__cutchars 1-8 names.txt"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief  Display n-st field from a column delimited file
# @params Values reuired columns (columns for cuting) and file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __cutcolumns 1,3,5 file.ini
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __cutcolumns() {
    COLUMNS=$1
    FILE=$2
    if [ -n "$COLUMNS" ] && [ -n "$FILE" ]; then
        if [ -e "$FILE" ] && [ -f "$FILE" ]; then
            cut -d -f $COLUMNS $FILE
            return $SUCCESS
        fi
        printf "%s\n" "Check FILE [$FILE] exist ?"
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE_COL
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
} 

#
# @brief  Diplay characters of every line in a file
# @params Values required chars (columns for cuting) and file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __cutchars 1-8 names.txt
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __cutchars() {
    CHARS=$1
    FILE=$2
    if [ -n "$CHARS" ] && [ -n "$FILE" ]; then
        if [ -e "$FILE" ] && [ -f "$FILE" ]; then
            cut -c $CHARS $FILE
            return $SUCCESS
        fi
        printf "%s\n" "Check FILE [$FILE] exist ?"
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE_CHA
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
