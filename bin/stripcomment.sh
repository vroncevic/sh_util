#!/bin/bash
#
# @brief   Strips out the comments (/* COMMENT */) in a C program
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=stripcomment
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[FILE] Path to C file code"
    [EX-PRE]="# Strips comments from C code"
    [EX]="__$UTIL_NAME /opt/test.c"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Strips out the comments (/* COMMENT */) in a C program
# @param  Value required path to C code
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __stripcomment "$FILE"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __stripcomment() {
    FILE=$1
    if [ -n "$FILE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Strips out the comments in a C file]"
		fi
        if [ -f "$FILE" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s" "Checking Code File "
			fi
            type=`file $1 | awk '{ print $2, $3, $4, $5 }'`
            correct_type="ASCII C program text"
            if [ "$type" != "$correct_type" ]; then
				if [ "$TOOL_DEBUG" == "true" ]; then                
					printf "%s\n" "[not ok]"
                	printf "%s\n" "This script works on C program files only"
				fi
                return $NOT_SUCCESS
            fi  
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "[ok]"
			fi
            sed '/^\/\*/d /.*\*\//d' $1
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
		LOG[MSG]="Check file [$FILE]"
		if [ "$TOOL_DEBUG" == "true" ]; then        
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

