#!/bin/bash
#
# @brief   Remove empty leading spaces from an ascii file and replace input file
# @version ver.1.0
# @date    Sun Oct 04 22:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=rmleads
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
    [ARG1]="[FILES] Name of file"
    [EX-PRE]="# Remove empty leading spaces from an ascii file"
    [EX]="__$TOOL /data/test.txt"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Remove empty leading spaces from an ascii file and replace input file
# @argument Value required name of ascii file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __rmleads $FILE_PATH
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __rmleads() {
    FILES=$@
    if [ -n "$FILES" ]; then
        tmp_1=/tmp/tmp.${RANDOM}$$
        trap 'rm -f $tmp_1 >/dev/null 2>&1' 0
        trap "exit 1" 1 2 3 15
        for a in "${FILES[@]}"
        do
            printf "%s\n" "Checking file: $a"
            if [ -f "$a" ]; then 
                file "$a" | grep -q text
                TXT_FILE=$?
                if [ $TXT_FILE -eq $SUCCESS ]; then
                    sed 's/^[ 	]*//' < "$a" > $tmp_1 && mv $tmp_1 "$a"
                else
                    printf "%s\n" "File [$a] is not an ascii type"
                fi
            fi
        done
        printf "%s\n" "Done..."
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
