#!/bin/bash
#
# @brief   Wrap text file at 80th column and replace file with the wrapped version
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=wraptext
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
    [ARG1]="[PATH] Path to the target(s)"
    [EX-PRE]="# Example running __$TOOL"
    [EX]="__$TOOL /data/"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Wrap text file at 80th column and replace file with the wrapped version
# @argument Value required file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __wraptext $FILES
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __wraptext() {
    FILES=$@
    if [ -n "$FILES" ]; then
        for a in "${FILES[@]}"
        do
            if [ -f "$a" ]; then
                printf "%s\n" "File [$a]"
                fmt -w 80 -s $a > /tmp/$$.tmp
                mv /tmp/$$.tmp $a
            else
                printf "%s\n" "File [$a] does not exist"
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
