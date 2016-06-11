#!/bin/bash
#
# @brief   Usage option
# @version ver.1.0
# @date    Mon May 18 11:17:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_USAGE=usage
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh

#
# @brief  Usage option
# @param  Value required structure (hash) 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
#   declare -A TOOL_USAGE=(
#	    [TOOL_NAME]="$TOOL_NAME"
#	    [ARG1]="argument 1"
#	    [ARG2]="argument 2"
#       ...
#	    [ARGn]="argument n"
#	    [EX-PRE]="# Comment for tool usage example"
#	    [EX]="Example: $TOOL_NAME arg1 arg2 ... argn"	
#   )
#
# __usage $TOOL_USAGE
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # disply usage for App/Tool/Script
# else
#   # false
#   # notify admin | user
# fi
#
function __usage() {
    local TOOL_USAGE=$1
    local TOOL_NAME=${TOOL_USAGE[TOOL_NAME]}
    local TOOL_EX_PRE=${TOOL_USAGE[EX-PRE]}
    local TOOL_EX=${TOOL_USAGE[EX]}
    local FUNC=${FUNCNAME[0]}
    local FPARENT=${FUNCNAME[1]}
    local MSG=""
    if [ -n "$TOOL_NAME" ] && [ -n "$TOOL_EX_PRE" ] && [ -n "$TOOL_EX" ]; then
        printf "%s\n" "  [Usage] $TOOL_NAME [OPTIONS]"
        printf "%s\n" "  [OPTIONS]"
        for argument in "${!TOOL_USAGE[@]}"; 
        do 
            if [ "$argument" != "EX" ] && 
               [ "$argument" != "EX-PRE" ] && 
			   [ "$argument" != "TOOL_NAME" ]; then
                printf "%s\n" "  ${TOOL_USAGE["$argument"]}"
            fi
        done
        printf "%s\n" "  ${TOOL_USAGE[EX-PRE]}"
        printf "%s\n" "  ${TOOL_USAGE[EX]}"
        printf "%s\n" "  [help | h] print this option"
        return $SUCCESS
    fi
    MSG="  Error at $FPARENT, provide argument TOOL_USAGE structure of:"
    printf "%s\n" "$MSG"
    MSG="  [TOOL_NAME], [ARG1], [ARG2], ...[ARGn], [EX-PRE] and [EX] for $FUNC"
    printf "%s\n" "$MSG"
    MSG="  [TOOL_NAME] Tool or Application name"
    printf "%s\n" "$MSG"
    MSG="  [ARG1]      First argument for Tool or Application"
    printf "%s\n" "$MSG"
    MSG="$  [ARG2]      Second argument for Tool or Application"
    printf "%s\n" "$MSG"
    MSG="  [ARGn]      Last argument for Tool or Application"
    printf "%s\n" "$MSG"
    MSG="  [EX-PRE]    Comment line for example command line"
    printf "%s\n" "$MSG"
    MSG="  [EX]        Example of command line"
    printf "%s\n" "$MSG"
    printf "%s\n" "  $FUNC [TOOL_USAGE]"
    return $NOT_SUCCESS
}
