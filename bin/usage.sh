#!/bin/bash
#
# @brief   Usage option for Tool/Script/Application
# @version ver.1.0
# @date    Mon May 18 11:17:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_USAGE=usage
UTIL_USAGE_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_USAGE_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh

#
# @brief  Usage option for Tool/Script/Application
# @param  Value required structure (hash) 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
#   declare -A USAGE=(
#	    [TOOL]="$TOOL"
#	    [ARG1]="argument 1"
#	    [ARG2]="argument 2"
#       ...
#	    [ARGn]="argument n"
#	    [EX-PRE]="# Comment for tool usage example"
#	    [EX]="Example: $TOOL arg1 arg2 ... argn"	
#   )
#
# __usage $USAGE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # disply usage for App/Tool/Script
# else
#   # false
#   # notify admin | user
# fi
#
function __usage() {
	local USAGE=$1
    local TOOL=${USAGE[TOOL]}
    local TOOL_EX_PRE=${USAGE[EX-PRE]}
    local TOOL_EX=${USAGE[EX]}
    local FUNC=${FUNCNAME[0]}
    local FPARENT=${FUNCNAME[1]}
    local MSG=""
    if [ -n "$TOOL" ] && [ -n "$TOOL_EX_PRE" ] && [ -n "$TOOL_EX" ]; then
        printf "%s\n" "  [Usage] $TOOL [OPTIONS]"
        printf "%s\n" "  [OPTIONS]"
        for argument in "${!USAGE[@]}"; 
        do 
            if [ "$argument" != "EX" ] && 
               [ "$argument" != "EX-PRE" ] && 
			   [ "$argument" != "TOOL" ]; then
                printf "%s\n" "  ${USAGE[$argument]}"
            fi
        done
        printf "%s\n" "  ${USAGE[EX-PRE]}"
        printf "%s\n" "  ${USAGE[EX]}"
        printf "%s\n" "  [help | h] print this option"
        return $SUCCESS
    fi
    MSG="  Error at $FPARENT, provide argument USAGE structure of:"
    printf "%s\n" "$MSG"
    MSG="  [TOOL], [ARG1], [ARG2], ...[ARGn], [EX-PRE] and [EX] for $FUNC"
    printf "%s\n\n" "$MSG"
    MSG="  [TOOL]      Name of Tool/Script/Application"
    printf "%s\n" "$MSG"
    MSG="  [ARG1]      First argument for Tool or Application"
    printf "%s\n" "$MSG"
    MSG="  [ARG2]      Second argument for Tool or Application"
    printf "%s\n" "$MSG"
    MSG="  [ARGn]      Last argument for Tool or Application"
    printf "%s\n" "$MSG"
    MSG="  [EX-PRE]    Comment line for example command line"
    printf "%s\n" "$MSG"
    MSG="  [EX]        Example of command line"
    printf "%s\n" "$MSG"
    printf "%s\n" "  $FUNC [USAGE]"
    return $NOT_SUCCESS
}

