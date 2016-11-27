#!/bin/bash
#
# @brief   Remove lines that contain words stored in a list
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_RMLINES=rmlines
UTIL_RMLINES_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_RMLINES_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A RMLINES_USAGE=(
    [TOOL]="__$UTIL_RMLINES"
    [ARG1]="[INPUT_FILE]  Name of file for operation"
    [ARG2]="[OUTPUT_FILE] Name of the resulting file"
    [EX-PRE]="# Create a file n bytes large"
    [EX]="__$UTIL_RMLINES /opt/test.txt /opt/result.txt"	
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
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | missing file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __rmlines() {
    local INPUT_FILE=$1
    local OUTPUT_FILE=$2
    if [ -n "$INPUT_FILE" ] && [ -n "$OUTPUT_FILE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking file [$INPUT_FILE]"
			printf "$DQUE" "$UTIL_RMLINES" "$FUNC" "$MSG"
		fi
        if [ -f "$INPUT_FILE" ]; then
            local tmp1=/tmp/tmp.${RANDOM}$$
            trap 'rm -f $tmp1 >/dev/null 2>&1' 0
            trap "exit 1" 1 2 3 15
            sed -e 's/ //g' -e 's-^-/-g' -e 's-$-/d-' $INPUT_FILE > $tmp1
            sed -f "$tmp1" "$OUTPUT_FILE"
			if [ "$TOOL_DBG" == "true" ]; then
            	printf "$DEND" "$UTIL_RMLINES" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		MSG="Please check file [$INPUT_FILE]"
		printf "$SEND" "$UTIL_RMLINES" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage $RMLINES_USAGE
    return $NOT_SUCCESS
}

