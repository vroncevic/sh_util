#!/bin/bash
#
# @brief   List files of same size in current dir
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=samesize
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
    [ARG1]="[DIR_PATH] Directory path"
    [EX-PRE]="# List files of same size in dir"
    [EX]="__$TOOL /data/"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief List files of same size in current dir
# @argument Value required path to directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __samesize $DIR_PATH
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __samesize() {
    DIR_PATH=$1
    if [ -n "$DIR_PATH" ]; then
        tmp_1=/tmp/tmp.${RANDOM}$$
        trap 'rm -f $tmp_1 >/dev/null 2>&1' 0
        trap "exit 2" 1 2 3 15
        for a in $DIR_PATH/*
        do
            f_size=$(set -- $(ls -l -- "$a"); echo $5)
            find . -maxdepth 1 -type f ! -name "$a" -size ${f_size}c > $tmp_1
            [ -s $tmp_1 ] && { echo file with same size as file \"$a\": ; cat $tmp_1; }
        done
        printf "%s\n" "Done..."
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
