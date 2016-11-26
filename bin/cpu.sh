#!/bin/bash
#
# @brief   Get CPU speed
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CPU=cpu
UTIL_CPU_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_CPU_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A CPU_USAGE=(
    ["TOOL"]="__$UTIL_CPU"
    ["ARG1"]="[CPU_SPEED] Show in GHz | MHz CPU speed"
    ["EX-PRE"]="# Example show in GHz CPU speed"
    ["EX"]="__$UTIL_CPU ghz"	
)

#
# @brief  Get CPU speed
# @param  Value required show in GHz | MHz CPU speed
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local CPU_SPEED="ghz"
# __cpu $CPU_SPEED
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | wrong argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __cpu() {
    local CPU_SPEED=$1
    if [ -n "$CPU_SPEED" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local CPUINFO=/proc/cpuinfo
		local GHZ='/cpu MHz/ {print $4 " / 1000"}'
		local MHZ='/cpu MHz/ {print $4}'
		local HZ=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking CPU speed"
			printf "$DSTA" "$UTIL_CPU" "$FUNC" "$MSG"
		fi
        if [ "$CPU_SPEED" == "ghz" ]; then
            HZ=$GHZ
		elif [ "$CPU_SPEED" == "mhz" ]; then
			HZ=$MHZ
		else
			printf "$SEND" "$UTIL_CPU" "$FUNC" "Wrong argument"
			return $NOT_SUCCESS
        fi
		local cpus=($({ echo scale=2; awk $HZ $CPUINFO; } | bc))
		printf "%s\n" "$cpus"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_CPU" "$FUNC" "Done"
		fi
		return $SUCCESS
    fi
    __usage "$(declare -p CPU_USAGE)"
    return $NOT_SUCCESS
}

