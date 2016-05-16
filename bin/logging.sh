#!/bin/bash
#
# @brief   Logging message to file
# @version ver.1.0
# @date    Thu Oct 08 18:55:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=logging
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[LOG]  Name of App/Tool/Script, flag, path and message"
    [EX-PRE]="# Example write LOG line structure to file"
    [EX]="__$UTIL_NAME \$LOG"	
)

#
# @brief  Logging message to file
# @param  Value required tool log structure (name, flag, path, message)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# LOG[TOOL]="wolan"               # Name of App/Tool/Script
# LOG[FLAG]="info"                # String flag info/error, type of log message
# LOG[PATH]="/opt/wolan/log/"     # Path to log file of tool
# LOG[MSG]="Simple log line"      # Message content for log line
#
# __logging $LOG
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
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
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Logging message to file]"
        	printf "%s" "Checking log directory "
		fi
        if [ ! -d "$LTP" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "[not exist]"
            	printf "%s\n" "Creating log directory [$LTP]"
			fi
            mkdir "$LTP"
        fi
        if [ -d "$LTP" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "[ok]"
			fi
            if [ "$LTF" == "info" ]; then
				if [ "$TOOL_DEBUG" == "true" ]; then
	                printf "%s\n" "Write info log"
				fi
                LOG_LINE="[`date`] INFO $LTM [host: `hostname`]"
            elif [ "$LTF" == "error" ]; then
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "Write error log"
				fi
                LOG_LINE="[`date`] ERROR $LTM [host: `hostname`]"
            else
                __usage $TOOL_USAGE
                return $NOT_SUCCESS
            fi
            echo "$LOG_LINE" >> "$LTP/$LTN.log"
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "Check log path [$LTP]"
		fi
        return $NOT_SUCCESS
    fi 
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

