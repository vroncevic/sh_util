#!/bin/bash
#
# @brief   Usage mechanism for Tool/Script/Application
# @version ver.1.0
# @date    Mon May 18 11:17:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_USAGE" ]; then
    readonly __SH_UTIL_USAGE=1

    UTIL_USAGE=usage
    UTIL_USAGE_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_USAGE_VERSION}
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
    #    declare -A USAGE=(
    #        [USAGE_TOOL]="$TOOL"
    #        [USAGE_ARG1]="argument 1"
    #        [USAGE_ARG2]="argument 2"
    #    ...
    #        [USAGE_ARGn]="argument n"
    #        [USAGE_EX_PRE]="# Comment for tool usage example"
    #        [USAGE_EX]="Example: $TOOL arg1 arg2 ... argn"
    #    )
    #
    # usage USAGE
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
        local -n USAGE=$1
        local TOOL=${USAGE[USAGE_TOOL]} TOOL_EX_PRE=${USAGE[USAGE_EX_PRE]}
        local TOOL_EX=${USAGE[USAGE_EX]} FUNC=${FUNCNAME[0]}
        local FPARENT=${FUNCNAME[1]} MSG="None" ARG
        if [[ -z "${TOOL}" || -z "${TOOL_EX_PRE}" || -z "${TOOL_EX}" ]]; then
            printf "%s\n" "  Error at ${FPARENT}, provide argument usage structure of:" >&2
            printf "%s\n" "  [USAGE_TOOL], [USAGE_ARG1],...[USAGE_ARGn] and [USAGE_EX]" >&2
            printf "%s\n" "  [USAGE_TOOL]    Name of Tool/Script/Application" >&2
            printf "%s\n" "  [USAGE_ARG1]    First argument for Tool or Application" >&2
            printf "%s\n" "  [USAGE_ARGN]    Last argument for Tool or Application" >&2
            printf "%s\n" "  [USAGE_EX_PRE]  Comment line for example command line" >&2
            printf "%s\n" "  [USAGE_EX]      Example of command line" >&2
            printf "%s\n\n" "  ${FUNC} [USAGE]" >&2
            return $NOT_SUCCESS
        fi
        printf "%s\n" "  [USAGE] ${TOOL} [OPTIONS]"
        printf "%s\n" "  [OPTIONS]"
        for ARG in "${!USAGE[@]}";
        do
            if [[ "$ARG" != "USAGE_TOOL" && "$ARG" != "USAGE_EX_PRE" && "$ARG" != "USAGE_EX" ]]; then
                printf "%s\n" "  ${USAGE[$ARG]}"
            fi
        done
        printf "%s\n" "  ${USAGE[USAGE_EX_PRE]}"
        printf "%s\n" "  ${USAGE[USAGE_EX]}"
        printf "%s\n\n" "  [help | h] print this option"
        return $SUCCESS
    }
fi
