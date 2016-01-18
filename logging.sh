#!/bin/bash
#
# @brief   Logging message line to file
# @version ver.1.0
# @date    Thu Oct 08 18:55:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=logging
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL_NAME"
    [ARG1]="[APP_TOOL_NAME]  Name of App/Tool/Script"
    [ARG2]="[LOG_FLAG]       String flag info/error, type of log message"
    [ARG3]="[LOG_PATH]       Path to log file of tool"
    [ARG4]="[MESSAGE]        Message content for log line"
    [EX-PRE]="# Example write LOG line structure to file"
    [EX]="__$TOOL_NAME \$LOG"	
)

#
# @brief Write LOG line to file
# @argument Value required tool log structure (tool name, log flag, log path, message)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __logging $LOG
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __logging() {
    LOG=$1
    LTN=${LOG[TOOL]}
    LTF=${LOG[FLAG]}
    LTP=${LOG[PATH]}
    LTM=${LOG[MSG]}
    if [ -n "$LTN" ] && [ -n "$LTF" ] && [ -n "$LTP" ] && [ -n "$LTM" ]; then
        LOG_LINE=""
        printf "%s" "Checking LOG Directory "
        if [ ! -d "$LTP" ]; then
            printf "%s\n" "[not exist]"
            printf "%s\n" "Creating LOG Directory [$LTP]"
            mkdir "$LTP"
        fi
        if [ -d "$LTP" ]; then
            printf "%s\n" "[ok]"
            if [ "$LTF" == "info" ]; then
                printf "%s\n" "Write info LOG..."
                LOG_LINE="[`date`] INFO $LTM [host: `hostname`]"
            elif [ "$LTF" == "error" ]; then
                printf "%s\n" "Write error LOG..."
                LOG_LINE="[`date`] ERROR $LTM [host: `hostname`]"
            else
                printf "%s\n" "Check LOG Flag [$LTF]"
                return $NOT_SUCCESS
            fi
            echo "$LOG_LINE" >> "$LTP/$LTN.log"
            return $SUCCESS
        fi
        printf "%s\n" "Check LOG Path [$LTP]"
        return $NOT_SUCCESS
    fi 
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}
