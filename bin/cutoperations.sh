#!/bin/bash
#
# @brief   Cut operations on files
# @version ver.1.0
# @date    Mon Jul 15 21:55:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=cutoperations
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE_COL=(
    [TOOL_NAME]="__cutcolumns"
    [ARG1]="[CUT_STRUCTURE] Columns for cuting and path"
    [EX-PRE]="# Example for cuting columns from file"
    [EX]="__cutcolumns \$CUT_STRUCTURE"	
)

declare -A TOOL_USAGE_CHA=(
    [TOOL_NAME]="__cutchars"
    [ARG1]="[CUT_STRUCTURE] Characters and path"
    [EX-PRE]="# Example for cuting characters from file"
    [EX]="__cutchars \$CUT_STRUCTURE"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Display n-st field from a column delimited file
# @param  Value reuired structure columns (columns for cuting) and file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# CUT_STRUCTURE[COL]=1,3,5
# CUT_STRUCTURE[FILE]="file.ini"
#
# __cutcolumns $CUT_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __cutcolumns() {
	CUT_STRUCTURE=$1
    COLUMNS=${CUT_STRUCTURE[COL]}
    FILE=${CUT_STRUCTURE[FILE]}
    if [ -n "$COLUMNS" ] && [ -n "$FILE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Cut columns from file]"
        	printf "%s" "Checking file [$FILE] "
		fi
        if [ -e "$FILE" ] && [ -f "$FILE" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
        		printf "%s\n" "[ok]"
			fi
            cut -d -f "$COLUMNS" "$FILE"
			if [ "$TOOL_DEBUG" == "true" ]; then
        		printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
		LOG[MSG]="Check file [$FILE]"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[not ok]"
        	printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE_COL
    return $NOT_SUCCESS
} 

#
# @brief  Diplay characters of every line in a file
# @param  Value required structure chars (columns for cuting) and file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# CUT_STRUCTURE[CHARS]=$chars
# CUT_STRUCTURE[FILE]=$file
#
# __cutchars $CUT_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __cutchars() {
	CUT_STRUCTURE=$1
    CHARS=${CUT_STRUCTURE[CHARS]}
    FILE=${CUT_STRUCTURE[FILE]}
    if [ -n "$CHARS" ] && [ -n "$FILE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Diplay characters of every line in a file]"
        	printf "%s" "Checking file [$FILE] "
		fi
        if [ -e "$FILE" ] && [ -f "$FILE" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
        		printf "%s\n" "[ok]"
			fi
            cut -c "$CHARS" "$FILE"
			if [ "$TOOL_DEBUG" == "true" ]; then
        		printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
		LOG[MSG]="Check file [$FILE]"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[not ok]"
        	printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE_CHA
    return $NOT_SUCCESS
}

