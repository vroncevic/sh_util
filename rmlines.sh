#!/bin/bash
#
# @brief   Remove lines that contain words stored in a list
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=rmlines
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
    [ARG1]="[INPUT_FILE] Name of tool or Application"
    [ARG2]="[OUTPUT_FILE] Name of tool or Application"
    [EX-PRE]="# Create a file n bytes large"
    [EX]="__$TOOL freshtool"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Remove lines that contain words stored in a list
# @argument Value required string input and output file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __rmlines $TARGET
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __rmlines() {
    INPUT_FILE=$1
    OUTPUT_FILE=$2
    if [ -n "$INPUT_FILE" ] && [ -n "$OUTPUT_FILE" ]; then
        if [ -f "$INPUT_FILE" ]; then
            tmp_1=/tmp/tmp.${RANDOM}$$
            trap 'rm -f $tmp_1 >/dev/null 2>&1' 0
            trap "exit 1" 1 2 3 15
            sed -e 's/ //g' -e 's-^-/-g' -e 's-$-/d-' $INPUT_FILE > $tmp_1
            sed -f $tmp_1 $OUTPUT_FILE
            printf "%s\n" "Done..."
            return $SUCCESS
        fi
        printf "%s\n" "Check file [$INPUT_FILE]"
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
