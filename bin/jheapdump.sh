#!/bin/bash
#
# @brief   Create a heap dump of a Java process
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=jheapdump
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[PID_OF_JVM] PID of JVM"
    [EX-PRE]="# Create a heap dump of a Java process"
    [EX]="__$UTIL_NAME 2334"	
)

#
# @brief  Create a heap dump of a Java process
# @param  Value required pid of java app
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __jheapdump "$PID_OF_JVM"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __jheapdump() {
    PID_OF_JVM=$1
    if [ -n "$PID_OF_JVM" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Create a heap dump of a Java process]"
		fi
        i="0"
        while [ $i -lt 10 ]
        do
            jmap -dump:file=/tmp/java-`date +%s`.hprof $PID_OF_JVM
            sleep 30
            i=$[$i+1]
        done
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

