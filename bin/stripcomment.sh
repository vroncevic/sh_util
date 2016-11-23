#!/bin/bash
#
# @brief   Strips out the comments (/* COMMENT */) in a C program
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_STRIPCOMMENT=stripcomment
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A STRIPCOMMENT_USAGE=(
    [TOOL_NAME]="__$UTIL_STRIPCOMMENT"
    [ARG1]="[FILE] Path to C file code"
    [EX-PRE]="# Strips comments from C code"
    [EX]="__$UTIL_STRIPCOMMENT /opt/test.c"	
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
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | not ascii type of file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __stripcomment() {
    local FILE=$1
    if [ -n "$FILE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
        if [ -f "$FILE" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="Checking Code File"
				printf "$DQUE" "$UTIL_STRIPCOMMENT" "$FUNC" "$MSG"
			fi
            local type=`file $1 | awk '{ print $2, $3, $4, $5 }'`
            local correct_type="ASCII C program text"
            if [ "$type" != "$correct_type" ]; then
				if [ "$TOOL_DBG" == "true" ]; then                
					printf "%s\n" "[not ok]"
                	MSG="This script works on C program files only"
					printf "$DSTA" "$UTIL_STRIPCOMMENT" "$FUNC" "$MSG"
				fi
                return $NOT_SUCCESS
            fi  
			if [ "$TOOL_DBG" == "true" ]; then
            	printf "%s\n" "[ok]"
			fi
            sed '/^\/\*/d /.*\*\//d' $1
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "$DEND" "$UTIL_STRIPCOMMENT" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
        MSG="Please check file [$FILE]"
		printf "$SEND" "$UTIL_STRIPCOMMENT" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage $STRIPCOMMENT_USAGE
    return $NOT_SUCCESS
}

