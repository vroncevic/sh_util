#!/bin/bash
#
# @brief   Remove lines that contain words stored in a list
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=rmlines
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[INPUT_FILE] Name of tool or Application"
    [ARG2]="[OUTPUT_FILE] Name of tool or Application"
    [EX-PRE]="# Create a file n bytes large"
    [EX]="__$UTIL_NAME freshtool"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Remove lines that contain words stored in a list
# @param  Value required string input and output file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __rmlines "$IN_FILE" "$OUT_FILE"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __rmlines() {
    INPUT_FILE=$1
    OUTPUT_FILE=$2
    if [ -n "$INPUT_FILE" ] && [ -n "$OUTPUT_FILE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Remove lines that contain words stored in a list]"
			printf "%s\n" "Checking file [$INPUT_FILE]"
		fi
        if [ -f "$INPUT_FILE" ]; then
            tmp_1=/tmp/tmp.${RANDOM}$$
            trap 'rm -f $tmp_1 >/dev/null 2>&1' 0
            trap "exit 1" 1 2 3 15
            sed -e 's/ //g' -e 's-^-/-g' -e 's-$-/d-' $INPUT_FILE > $tmp_1
            sed -f "$tmp_1" "$OUTPUT_FILE"
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
		LOG[MSG]="Check file [$INPUT_FILE]"
		if [ "$TOOL_DEBUG" == "true" ]; then        
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

