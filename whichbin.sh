#!/bin/bash
#
# @brief   Locate binary executable
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=whichbin
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
    [ARG1]="[PATH] Path to destionation"
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
# @brief Show links
# @argument Value required path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __follow_link $PATH
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __follow_link() {
    SRC_FILE=$1
    FILE=$(which $SRC_FILE)
    if [ $FILE -eq $NOT_SUCCESS ]; then
        printf "%s\n" "[$FILE] not an executable..."
        return $NOT_SUCCESS
    fi
    if [ -L $FILE ]; then
        printf "%s\n"  "Symbolic Link [$FILE]"
        cd $(dirname $FILE)
        __follow_link $(set -- $(ls -l $SRC_FILE); shift 10; echo $SRC_FILE)
    else
        ls -l $FILE
    fi
    return $SUCCESS
}

#
# @brief Show links and path to executable
# @argument Value required path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __whichbin $PATH
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __whichbin() {
    FILES=$@
    if [ -n "$FILES" ]; then 
        for a in ${FILES[@]}
        do
                __follow_link $a
        done 
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
