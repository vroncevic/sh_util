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
#	    [USAGE_TOOL]="$TOOL"
#	    [USAGE_ARG1]="argument 1"
#	    [USAGE_ARG2]="argument 2"
#       ...
#	    [USAGE_ARGn]="argument n"
#	    [USAGE_EX_PRE]="# Comment for tool usage example"
#	    [USAGE_EX]="Example: $TOOL arg1 arg2 ... argn"	
#   )
#
# __usage USAGE
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
	local -n USAGE=$1
    local TOOL=${USAGE[USAGE_TOOL]}
    local TOOL_EX_PRE=${USAGE[USAGE_EX_PRE]}
    local TOOL_EX=${USAGE[USAGE_EX]}
    local FUNC=${FUNCNAME[0]}
    local FPARENT=${FUNCNAME[1]}
    local MSG="None"
    if [ -n "$TOOL" ] && [ -n "$TOOL_EX_PRE" ] && [ -n "$TOOL_EX" ]; then
        printf "%s\n" "  [Usage] $TOOL [OPTIONS]"
        printf "%s\n" "  [OPTIONS]"
        for argument in "${!USAGE[@]}"; 
        do 
            if [ "$argument" != "USAGE_EX" ] && 
               [ "$argument" != "USAGE_EX_PRE" ] && 
			   [ "$argument" != "USAGE_TOOL" ]; then
                printf "%s\n" "  ${USAGE["$argument"]}"
            fi
        done
        printf "%s\n" "  ${USAGE[USAGE_EX_PRE]}"
        printf "%s\n" "  ${USAGE[USAGE_EX]}"
        printf "%s\n" "  [help | h] print this option"
        return $SUCCESS
    fi
    MSG="  Error at $FPARENT, provide argument USAGE structure of:"
    printf "%s\n" "$MSG"
    MSG="  [USAGE_TOOL], [USAGE_ARG1], [USAGE_ARG2], ...[USAGE_ARGn], [USAGE_EX_PRE] and [USAGE_EX] for $FUNC"
    printf "%s\n\n" "$MSG"
    MSG="  [USAGE_TOOL]      Name of Tool/Script/Application"
    printf "%s\n" "$MSG"
    MSG="  [USAGE_ARG1]      First argument for Tool or Application"
    printf "%s\n" "$MSG"
    MSG="  [USAGE_ARG2]      Second argument for Tool or Application"
    printf "%s\n" "$MSG"
    MSG="  [USAGE_ARGn]      Last argument for Tool or Application"
    printf "%s\n" "$MSG"
    MSG="  [USAGE_EX_PRE]    Comment line for example command line"
    printf "%s\n" "$MSG"
    MSG="  [USAGE_EX]        Example of command line"
    printf "%s\n" "$MSG"
    printf "%s\n" "  $FUNC [USAGE]"
    return $NOT_SUCCESS
}

