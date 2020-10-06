#!/bin/bash
#
# @brief   Usage mechanism for Tool/Script/Application
# @version ver.1.0.0
# @date    Mon May 18 11:17:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_Usage=usage
UTIL_Usage_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_Usage_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh

#
# @brief  Usage mechanism for Tool/Script/Application
# @param  Value required structure (hash) with parameters
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
#    declare -A Usage=(
#        [Usage_TOOL]="$TOOL"
#        [Usage_ARG1]="argument 1"
#        [Usage_ARG2]="argument 2"
#    ...
#        [Usage_ARGn]="argument n"
#        [Usage_EX_PRE]="# Comment for tool usage example"
#        [Usage_EX]="Example: $TOOL arg1 arg2 ... argn"
#    )
#
# usage Usage
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # disply usage for App/Tool/Script
# else
#    # false
#    # notify admin | user
# fi
#
function usage {
    local -n Usage=$1
    local TOOL=${Usage[Usage_TOOL]} TOOL_EX_PRE=${Usage[Usage_EX_PRE]}
    local TOOL_EX=${Usage[Usage_EX]} FUNC=${FUNCNAME[0]}
    local FPARENT=${FUNCNAME[1]} MSG="None" ARG
    if [[ -n "${TOOL}" && -n "${TOOL_EX_PRE}" && -n "${TOOL_EX}" ]]; then
        printf "%s\n" "  [Usage] ${TOOL} [OPTIONS]"
        printf "%s\n" "  [OPTIONS]"
        for ARG in "${!Usage[@]}";
        do
            if [ "${ARG}" != "Usage_EX" ]; then
                if [ "${ARG}" != "Usage_EX_PRE" ]; then
                    if [ "${ARG}" != "Usage_TOOL" ]; then
                        printf "%s\n" "  ${Usage[$ARG]}"
                    fi
                fi
            fi
        done
        printf "%s\n" "  ${Usage[Usage_EX_PRE]}"
        printf "%s\n" "  ${Usage[Usage_EX]}"
        printf "%s\n\n" "  [help | h] print this option"
        return $SUCCESS
    fi
    printf "%s\n" "  Error at ${FPARENT}, provide argument Usage structure of:"
    printf "%s\n" "  [Usage_TOOL], [Usage_ARG1],...[Usage_ARGn] and [Usage_EX]"
    printf "%s\n" "  [Usage_TOOL]    Name of Tool/Script/Application"
    printf "%s\n" "  [Usage_ARG1]    First argument for Tool or Application"
    printf "%s\n" "  [Usage_ARG2]    Second argument for Tool or Application"
    printf "%s\n" "  [Usage_ARGn]    Last argument for Tool or Application"
    printf "%s\n" "  [Usage_EX_PRE]  Comment line for example command line"
    printf "%s\n" "  [Usage_EX]      Example of command line"
    printf "%s\n\n" "  ${FUNC} [Usage]"
    return $NOT_SUCCESS
}

