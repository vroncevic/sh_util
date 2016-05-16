#!/bin/bash
#
# @brief   Get CPU speed
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=cpu
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[CPU_SPEED_GHZ] Show in GHz CPU speed"
    [EX-PRE]="# Example show in GHz CPU speed"
    [EX]="__$UTIL_NAME ghz"	
)

#
# @brief Get CPU speed
# @param Value required show in GHz CPU speed
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __cpu $CPU_SPEED_GHZ
#
function __cpu() {
    CPU_SPEED_GHZ=$1
    if [ -n "$CPU_SPEED_GHZ" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Checking CPU speed]"
		fi
        if [ "$CPU_SPEED_GHZ" -eq "ghz" ]; then
            cpus=($({ echo scale=2; awk '/cpu MHz/ {print $4 " / 1000"}' /proc/cpuinfo; } | bc))
            print "%s\n" "$cpus"
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
        cpus=($(awk '/cpu MHz/ {print $4}' /proc/cpuinfo))
        print "%s\n" "$cpus"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
		return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

