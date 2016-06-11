#!/bin/bash
#
# @brief   Cut operations on files
# @version ver.1.0
# @date    Mon Jul 15 21:55:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CUTOPERATIONS=cutoperations
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A COLUMN_USAGE=(
    [TOOL_NAME]="__cutcolumns"
    [ARG1]="[CUT_STRUCTURE] Columns for cuting and path"
    [EX-PRE]="# Example for cuting columns from file"
    [EX]="__cutcolumns \$CUT_STRUCTURE"	
)

declare -A CHARACTER_USAGE=(
    [TOOL_NAME]="__cutchars"
    [ARG1]="[CUT_STRUCTURE] Characters and path"
    [EX-PRE]="# Example for cuting characters from file"
    [EX]="__cutchars \$CUT_STRUCTURE"	
)

#
# @brief  Display n-st field from a column delimited file
# @param  Value reuired structure columns (columns for cuting) and file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A CUT_STRUCTURE=()
# CUT_STRUCTURE[COL]=1,3,5
# CUT_STRUCTURE[FILE]="file.ini"
#
# __cutcolumns $CUT_STRUCTURE
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | wrong argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __cutcolumns() {
	local CUT_STRUCTURE=$1
    local COLUMNS=${CUT_STRUCTURE[COL]}
    local FILE=${CUT_STRUCTURE[FILE]}
    if [ -n "$COLUMNS" ] && [ -n "$FILE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Checking file [$FILE]"
			printf "$DQUE" "$UTIL_CUTOPERATIONS" "$FUNC" "$MSG"
		fi
        if [ -e "$FILE" ] && [ -f "$FILE" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
        		printf "%s\n" "[ok]"
			fi
            cut -d -f "$COLUMNS" "$FILE"
			if [ "$TOOL_DBG" == "true" ]; then
        		printf "$DEND" "$UTIL_CUTOPERATIONS" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
			printf "%s\n" "[not ok]"
		fi
		MSG="Check file [$FILE]"
		printf "$SEND" "$UTIL_CUTOPERATIONS" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage $COLUMN_USAGE
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
# declare -A CUT_STRUCTURE=()
# CUT_STRUCTURE[CHARS]=$chars
# CUT_STRUCTURE[FILE]=$file
#
# __cutchars $CUT_STRUCTURE
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | wrong argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __cutchars() {
	local CUT_STRUCTURE=$1
    local CHARS=${CUT_STRUCTURE[CHARS]}
    local FILE=${CUT_STRUCTURE[FILE]}
    if [ -n "$CHARS" ] && [ -n "$FILE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Checking file [$FILE]"
			printf "$DQUE" "$UTIL_CUTOPERATIONS" "$FUNC" "$MSG"
		fi
        if [ -e "$FILE" ] && [ -f "$FILE" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
        		printf "%s\n" "[ok]"
			fi
            cut -c "$CHARS" "$FILE"
			if [ "$TOOL_DBG" == "true" ]; then
        		printf "$DEND" "$UTIL_CUTOPERATIONS" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
			printf "%s\n" "[not ok]"
		fi
		MSG="Check file [$FILE]"
		printf "$SEND" "$UTIL_CUTOPERATIONS" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage $CHARACTER_USAGE
    return $NOT_SUCCESS
}
