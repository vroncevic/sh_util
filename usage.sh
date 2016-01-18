#!/bin/bash
#
# @brief   Usage option
# @version ver.1.0
# @date    Mon May 18 11:17:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

SUCCESS=0
NOT_SUCCESS=1

#
# @brief Usage option
# @argument Value required TOOL_USAGE  is a hash structure 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
#	declare -A TOOL_USAGE=(
#		[TOOL_NAME]="$TOOL_NAME"
#	    [ARG1]="argument 1"
#	    [ARG2]="argument 2"
#       ...
#	    [ARGn]="argument n"
#	    [EX-PRE]="# Comment for tool usage example"
#	    [EX]="Example: $TOOL_NAME arg1 arg2 ... argn"	
#   )
#
# __usage $TOOL_USAGE
# USAGE=$?
#
# if [ $USAGE -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __usage() {
    TOOL_USAGE=$1
    TOOL_NAME=${TOOL_USAGE["TOOL_NAME"]}
    TOOL_EX_PRE=${TOOL_USAGE["EX-PRE"]}
    TOOL_EX=${TOOL_USAGE["EX"]}
    if [ -n "$TOOL_NAME" ] && [ -n "$TOOL_EX_PRE" ] && [ -n "$TOOL_EX" ]; then
        printf "%s\n" "  [Usage] $TOOL_NAME [OPTIONS]"
        printf "%s\n" "  [OPTIONS]"
        for argument in "${!TOOL_USAGE[@]}"; 
        do 
            if [ "$argument" != "EX" ] && [ "$argument" != "EX-PRE" ] && [ "$argument" != "TOOL_NAME" ]; then
                printf "%s\n" "		${TOOL_USAGE["$argument"]}"
            fi
        done
        printf "%s\n" "		${TOOL_USAGE[EX-PRE]}"
        printf "%s\n" "		${TOOL_USAGE[EX]}"
        printf "%s\n" "		[help | h] print this option"
        return $SUCCESS
    fi 
    printf "%s\n" "  Error at ${FUNCNAME[1]}, provide argument TOOL_USAGE structure of:"
    printf "%s\n" "  [TOOL_NAME], [ARG1], [ARG2], ...[ARGn], [EX-PRE] and [EX] for ${FUNCNAME[0]}"
    printf "%s\n" "  [TOOL_NAME] Tool or Application name"
    printf "%s\n" "  [ARG1]      First argument for Tool or Application"
    printf "%s\n" "  [ARG2]      Second argument for Tool or Application"
    printf "%s\n" "  [ARGn]      Last argument for Tool or Application"
    printf "%s\n" "  [EX-PRE]    Comment line for example command line"
    printf "%s\n" "  [EX]        Example of command line"
    printf "%s\n" "  ${FUNCNAME[0]} [TOOL_USAGE]"
    return $NOT_SUCCESS
}
