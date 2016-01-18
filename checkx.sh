#!/bin/bash
#
# @brief   Checking X Server
# @version ver.1.0
# @date    Fri Okt 04 17:55:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=checkx
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
    [ARG1]="[XINIT] Instance of tool for running X session"
    [EX-PRE]="# Example checking X Server"
    [EX]="__$TOOL \"xinit\""
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Checking X Server
# @argument Value required name of init process
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkx "xinit"
# CHECK_X=$?
#
# if [ $CHECK_X -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __checkx() {
    X=$1
    if [ -n "$X" ]; then
        printf "%s" "Checking X Server "
        XINIT=$(ps aux | grep -q $X)
        if [ $XINIT -eq $SUCCESS ]; then
                printf "%s\n" "[up and running]"
                return $SUCCESS
        fi
        printf "%s\n" "[down]"
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
