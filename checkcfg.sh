#!/bin/bash
#
# @brief   Checking Configuration File of App/Tool/Script (*.cfg)
# @version ver.1.0
# @date    Wed Sep 16 10:22:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=checkcfg
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
    [ARG1]="[TOOL_CFG] Name of Configuration file"
    [EX-PRE]="# Example checking CFG file"
    [EX]="__$TOOL /etc/test.cfg"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Check Configuration File exist/regular/noempty
# @argument Value required configuration file path 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkcfg $CFG_FILE
# CHECK_CFG=$?
#
# if [ $CHECK_CFG -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __checkcfg() {
    CFG_FILE=$1
    if [ -n "$CFG_FILE" ]; then
        printf "%s" "Checking CFG file [$CFG_FILE] "
        if [ -e "$CFG_FILE" ] && [ -f "$CFG_FILE" ] && [ -s "$CFG_FILE" ]; then
            printf "%s\n" "[ok]"
            return $SUCCESS
        else
            printf "%s\n" "[not ok]"
            printf "%s\n" "Check is [$CFG_FILE] regular file/empty !"
            return $NOT_SUCCESS
        fi
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
