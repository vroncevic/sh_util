#!/bin/bash
#
# @brief   Check tool (does exist in system)
# @version ver.1.0
# @date    Mon Jul 15 20:57:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=checktool
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
    [TOOL_NAME]="__$TOOL_NAME"
    [ARG1]="[TOOL_NAME] Name of App/Tool/Script"
    [EX-PRE]="# Example checking Java tool"
    [EX]="__$TOOL_NAME java"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Check tool (does exist and is executable)
# @argument Value required App/Tool/Script name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checktool $TOOL_NAME
# CHECK_TOOL=$?
#
# if [ $CHECK_TOOL -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __checktool() {
    APP_TOOL_NAME=$1
    if [ -n "$APP_TOOL_NAME" ]; then
        printf "%s" "Checking tool [$APP_TOOL_NAME] "
        if [ -e "$APP_TOOL_NAME" ] && [ -x "$APP_TOOL_NAME" ]; then
            printf "%s\n" "[ok]"
            return $SUCCESS
        fi 
        printf "%s\n" "[not ok]"
        printf "%s\n" "Check is tool [$APP_TOOL_NAME] installed"
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
